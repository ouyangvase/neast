import * as cdk from "aws-cdk-lib";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import * as ecr from "aws-cdk-lib/aws-ecr";
import * as ecs from "aws-cdk-lib/aws-ecs";
import * as elbv2 from "aws-cdk-lib/aws-elasticloadbalancingv2";
import * as logs from "aws-cdk-lib/aws-logs";
import * as secretsmanager from "aws-cdk-lib/aws-secretsmanager";
import * as ssm from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

export interface ApiStackProps extends cdk.StackProps {
  envName: string;
  productionReady: boolean;
  vpc: ec2.Vpc;
  cluster: ecs.ICluster;
  listener: elbv2.IApplicationListener;
  ecsSecurityGroup: ec2.SecurityGroup;
  repository: ecr.IRepository;
  imageTag: string;
  hostHeader: string;
  listenerPriority: number;
  dbSecret: secretsmanager.ISecret;
  dbEndpointAddress: string;
  redisHost: string;
  redisPort: string;
  apiEnvSecret: secretsmanager.ISecret;
}

/** Keys injected from the /neast/<env>/api/env JSON secret. */
const API_ENV_SECRET_KEYS = [
  "FIUU_MERCHANT_ID",
  "FIUU_VERIFY_KEY",
  "FIUU_SECRET_KEY",
  "FIUU_CURRENCY",
  "FIUU_COUNTRY",
  "PAYMENT_H5_BASE_URL",
  "REFERR_INVITE_URL",
  "MERCHANT_SHARE_BASE_URL",
  "APP_STORE_URL",
  "GOOGLE_PLAY_URL",
  "OWNER_APP_STORE_URL",
  "OWNER_GOOGLE_PLAY_URL",
  "MERCHANT_APP_STORE_URL",
  "MERCHANT_GOOGLE_PLAY_URL",
  "FIREBASE_CREDENTIALS",
  "SHOW_ALPHA_NOTICE_USER",
  "SHOW_ALPHA_NOTICE_MERCHANT",
  "SHOW_ALPHA_NOTICE_LANDLORD",
];

/**
 * Hyperf API on ECS Fargate (container port 9512), fronted by an ALB
 * host-header rule for api.<domain>. Health check hits /health.
 */
export class ApiStack extends cdk.Stack {
  public readonly service: ecs.FargateService;

  constructor(scope: Construct, id: string, props: ApiStackProps) {
    super(scope, id, props);

    const logGroup = new logs.LogGroup(this, "LogGroup", {
      logGroupName: `/ecs/neast-${props.envName}-api`,
      retention: props.productionReady
        ? logs.RetentionDays.ONE_YEAR
        : logs.RetentionDays.ONE_WEEK,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
    });

    const task = new ecs.FargateTaskDefinition(this, "Task", {
      cpu: 512,
      memoryLimitMiB: 1024,
    });

    const secrets: Record<string, ecs.Secret> = {
      DB_USERNAME: ecs.Secret.fromSecretsManager(props.dbSecret, "username"),
      DB_PASSWORD: ecs.Secret.fromSecretsManager(props.dbSecret, "password"),
    };
    for (const key of API_ENV_SECRET_KEYS) {
      secrets[key] = ecs.Secret.fromSecretsManager(props.apiEnvSecret, key);
    }

    task.addContainer("api", {
      image: ecs.ContainerImage.fromEcrRepository(
        props.repository,
        props.imageTag,
      ),
      portMappings: [{ containerPort: 9512 }],
      logging: ecs.LogDrivers.awsLogs({
        logGroup,
        streamPrefix: "api",
      }),
      environment: {
        APP_NAME: "NEAST",
        APP_ENV: "prod",
        APP_URL: `https://${props.hostHeader}`,
        DB_HOST: props.dbEndpointAddress,
        DB_PORT: "3306",
        DB_DATABASE: "neast",
        REDIS_HOST: props.redisHost,
        REDIS_PORT: props.redisPort,
        REDIS_DB: "0",
      },
      secrets,
    });

    this.service = new ecs.FargateService(this, "Service", {
      cluster: props.cluster,
      taskDefinition: task,
      desiredCount: 1,
      assignPublicIp: true,
      vpcSubnets: { subnetType: ec2.SubnetType.PUBLIC },
      securityGroups: [props.ecsSecurityGroup],
      minHealthyPercent: 0,
      maxHealthyPercent: 200,
      circuitBreaker: { rollback: true },
      // Allows SSM port-forwarding through the task to reach private RDS
      // (schema seeding, ops). See .github/DEPLOYMENT_SECRETS.md.
      enableExecuteCommand: true,
    });

    const targetGroup = new elbv2.ApplicationTargetGroup(this, "TargetGroup", {
      vpc: props.vpc,
      port: 9512,
      protocol: elbv2.ApplicationProtocol.HTTP,
      targetType: elbv2.TargetType.IP,
      targets: [this.service],
      healthCheck: {
        path: "/health",
        healthyHttpCodes: "200",
        interval: cdk.Duration.seconds(30),
      },
      deregistrationDelay: cdk.Duration.seconds(15),
    });

    new elbv2.ApplicationListenerRule(this, "HostRule", {
      listener: props.listener,
      priority: props.listenerPriority,
      conditions: [elbv2.ListenerCondition.hostHeaders([props.hostHeader])],
      targetGroups: [targetGroup],
    });

    new ssm.StringParameter(this, "ApiUrlParam", {
      parameterName: `/neast/${props.envName}/api/url`,
      stringValue: `https://${props.hostHeader}`,
    });
  }
}
