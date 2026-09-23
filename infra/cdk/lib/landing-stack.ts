import * as cdk from "aws-cdk-lib";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import * as ecr from "aws-cdk-lib/aws-ecr";
import * as ecs from "aws-cdk-lib/aws-ecs";
import * as elbv2 from "aws-cdk-lib/aws-elasticloadbalancingv2";
import * as logs from "aws-cdk-lib/aws-logs";
import * as ssm from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

export interface LandingStackProps extends cdk.StackProps {
  envName: string;
  productionReady: boolean;
  vpc: ec2.Vpc;
  cluster: ecs.ICluster;
  listener: elbv2.IApplicationListener;
  ecsSecurityGroup: ec2.SecurityGroup;
  repository: ecr.IRepository;
  imageTag: string;
  hostHeaders: string[];
  listenerPriority: number;
}

/**
 * Next.js landing on ECS Fargate (container port 3000), fronted by an ALB
 * host-header rule for the apex + www hostnames.
 */
export class LandingStack extends cdk.Stack {
  public readonly service: ecs.FargateService;

  constructor(scope: Construct, id: string, props: LandingStackProps) {
    super(scope, id, props);

    const logGroup = new logs.LogGroup(this, "LogGroup", {
      logGroupName: `/ecs/neast-${props.envName}-landing`,
      retention: props.productionReady
        ? logs.RetentionDays.ONE_YEAR
        : logs.RetentionDays.ONE_WEEK,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
    });

    const task = new ecs.FargateTaskDefinition(this, "Task", {
      cpu: 256,
      memoryLimitMiB: 512,
    });

    task.addContainer("landing", {
      image: ecs.ContainerImage.fromEcrRepository(
        props.repository,
        props.imageTag,
      ),
      portMappings: [{ containerPort: 3000 }],
      logging: ecs.LogDrivers.awsLogs({
        logGroup,
        streamPrefix: "landing",
      }),
      environment: {
        NODE_ENV: "production",
      },
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
    });

    const targetGroup = new elbv2.ApplicationTargetGroup(this, "TargetGroup", {
      vpc: props.vpc,
      port: 3000,
      protocol: elbv2.ApplicationProtocol.HTTP,
      targetType: elbv2.TargetType.IP,
      targets: [this.service],
      healthCheck: {
        path: "/",
        healthyHttpCodes: "200",
        interval: cdk.Duration.seconds(30),
      },
      deregistrationDelay: cdk.Duration.seconds(15),
    });

    new elbv2.ApplicationListenerRule(this, "HostRule", {
      listener: props.listener,
      priority: props.listenerPriority,
      conditions: [elbv2.ListenerCondition.hostHeaders(props.hostHeaders)],
      targetGroups: [targetGroup],
    });

    new ssm.StringParameter(this, "LandingUrlParam", {
      parameterName: `/neast/${props.envName}/landing/url`,
      stringValue: `https://www.${props.hostHeaders[0].replace(/^www\./, "")}`,
    });
  }
}
