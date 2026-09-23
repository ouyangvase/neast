import * as cdk from "aws-cdk-lib";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import * as elasticache from "aws-cdk-lib/aws-elasticache";
import * as rds from "aws-cdk-lib/aws-rds";
import * as secretsmanager from "aws-cdk-lib/aws-secretsmanager";
import * as ssm from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

export interface DataStackProps extends cdk.StackProps {
  envName: string;
  productionReady: boolean;
  vpc: ec2.Vpc;
  ecsSecurityGroup: ec2.SecurityGroup;
}

/**
 * Data layer: RDS MySQL 8 (single-AZ, private), ElastiCache Redis 7
 * (single node, SG-restricted — no TLS/AUTH because the Hyperf redis client
 * config has no TLS scheme support), and the fill-later API env secret.
 */
export class DataStack extends cdk.Stack {
  public readonly instance: rds.DatabaseInstance;
  public readonly dbSecret: secretsmanager.ISecret;
  public readonly redisEndpointAddress: string;
  public readonly redisEndpointPort: string;
  public readonly apiEnvSecret: secretsmanager.ISecret;

  constructor(scope: Construct, id: string, props: DataStackProps) {
    super(scope, id, props);

    const dbSecurityGroup = new ec2.SecurityGroup(this, "DbSecurityGroup", {
      vpc: props.vpc,
      allowAllOutbound: false,
    });
    dbSecurityGroup.addIngressRule(
      props.ecsSecurityGroup,
      ec2.Port.tcp(3306),
      "MySQL from ECS tasks",
    );

    this.instance = new rds.DatabaseInstance(this, "Mysql", {
      engine: rds.DatabaseInstanceEngine.mysql({
        version: rds.MysqlEngineVersion.VER_8_0_39,
      }),
      instanceType: ec2.InstanceType.of(
        ec2.InstanceClass.T4G,
        ec2.InstanceSize.MICRO,
      ),
      vpc: props.vpc,
      vpcSubnets: { subnetType: ec2.SubnetType.PRIVATE_ISOLATED },
      securityGroups: [dbSecurityGroup],
      credentials: rds.Credentials.fromGeneratedSecret("admin", {
        secretName: `/neast/${props.envName}/rds/credentials`,
      }),
      databaseName: "neast",
      allocatedStorage: 20,
      storageType: rds.StorageType.GP3,
      storageEncrypted: true,
      multiAz: false,
      publiclyAccessible: false,
      deletionProtection: props.productionReady,
      removalPolicy: props.productionReady
        ? cdk.RemovalPolicy.RETAIN
        : cdk.RemovalPolicy.DESTROY,
      backupRetention: props.productionReady
        ? cdk.Duration.days(7)
        : cdk.Duration.days(0),
    });
    this.dbSecret = this.instance.secret!;

    const redisSecurityGroup = new ec2.SecurityGroup(this, "RedisSecurityGroup", {
      vpc: props.vpc,
      allowAllOutbound: false,
    });
    redisSecurityGroup.addIngressRule(
      props.ecsSecurityGroup,
      ec2.Port.tcp(6379),
      "Redis from ECS tasks",
    );

    const redisSubnetGroup = new elasticache.CfnSubnetGroup(this, "RedisSubnetGroup", {
      cacheSubnetGroupName: `neast-${props.envName}-redis`,
      description: "NEAST Redis subnets",
      subnetIds: props.vpc.isolatedSubnets.map((s) => s.subnetId),
    });

    const redis = new elasticache.CfnReplicationGroup(this, "Redis", {
      replicationGroupDescription: `NEAST ${props.envName} Redis`,
      engine: "redis",
      engineVersion: "7.1",
      cacheNodeType: "cache.t4g.micro",
      numCacheClusters: 1,
      automaticFailoverEnabled: false,
      cacheSubnetGroupName: redisSubnetGroup.ref,
      securityGroupIds: [redisSecurityGroup.securityGroupId],
      atRestEncryptionEnabled: false,
      transitEncryptionEnabled: false,
    });
    this.redisEndpointAddress = redis.attrPrimaryEndPointAddress;
    this.redisEndpointPort = redis.attrPrimaryEndPointPort;

    // Filled by the operator before the first API deploy (Fiuu keys, store
    // URLs, Firebase credentials, ...). CDK intentionally never sets a value
    // so later deploys do not clobber the real secrets.
    this.apiEnvSecret = new secretsmanager.Secret(this, "ApiEnvSecret", {
      secretName: `/neast/${props.envName}/api/env`,
      description:
        "NEAST API runtime env (Fiuu keys, store URLs, Firebase credentials). Fill before the first API deploy.",
    });

    new ssm.StringParameter(this, "RdsEndpointParam", {
      parameterName: `/neast/${props.envName}/rds/endpoint`,
      stringValue: this.instance.dbInstanceEndpointAddress,
    });
    new ssm.StringParameter(this, "RedisEndpointParam", {
      parameterName: `/neast/${props.envName}/redis/endpoint`,
      stringValue: this.redisEndpointAddress,
    });
  }
}
