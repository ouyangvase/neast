import * as cdk from "aws-cdk-lib";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import * as ecr from "aws-cdk-lib/aws-ecr";
import * as ecs from "aws-cdk-lib/aws-ecs";
import * as elbv2 from "aws-cdk-lib/aws-elasticloadbalancingv2";
import * as s3 from "aws-cdk-lib/aws-s3";
import * as ssm from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

export interface NetworkStackProps extends cdk.StackProps {
  envName: string;
  productionReady: boolean;
  domainName: string;
  certificateArn: string;
  apiSubdomain: string;
}

/**
 * Shared network layer: VPC (public subnets only, no NAT — first-phase cost
 * posture), ECS cluster, internet-facing ALB with the ACM cert, ECR repos,
 * and the SSM params the workflows read.
 */
export class NetworkStack extends cdk.Stack {
  public readonly vpc: ec2.Vpc;
  public readonly cluster: ecs.Cluster;
  public readonly listener: elbv2.ApplicationListener;
  public readonly ecsSecurityGroup: ec2.SecurityGroup;
  public readonly apiRepository: ecr.Repository;
  public readonly landingRepository: ecr.Repository;

  constructor(scope: Construct, id: string, props: NetworkStackProps) {
    super(scope, id, props);

    this.vpc = new ec2.Vpc(this, "Vpc", {
      maxAzs: 2,
      natGateways: 0,
      subnetConfiguration: [
        {
          name: "public",
          subnetType: ec2.SubnetType.PUBLIC,
          cidrMask: 24,
        },
        {
          name: "isolated",
          subnetType: ec2.SubnetType.PRIVATE_ISOLATED,
          cidrMask: 24,
        },
      ],
    });

    this.cluster = new ecs.Cluster(this, "Cluster", {
      vpc: this.vpc,
      clusterName: `neast-${props.envName}`,
    });

    const albSecurityGroup = new ec2.SecurityGroup(this, "AlbSecurityGroup", {
      vpc: this.vpc,
      allowAllOutbound: true,
    });
    albSecurityGroup.addIngressRule(ec2.Peer.anyIpv4(), ec2.Port.tcp(80), "HTTP redirect");
    albSecurityGroup.addIngressRule(ec2.Peer.anyIpv4(), ec2.Port.tcp(443), "HTTPS");

    this.ecsSecurityGroup = new ec2.SecurityGroup(this, "EcsSecurityGroup", {
      vpc: this.vpc,
      allowAllOutbound: true,
    });
    this.ecsSecurityGroup.addIngressRule(
      albSecurityGroup,
      ec2.Port.tcp(9512),
      "API from ALB",
    );
    this.ecsSecurityGroup.addIngressRule(
      albSecurityGroup,
      ec2.Port.tcp(3000),
      "Landing from ALB",
    );

    const accessLogsBucket = new s3.Bucket(this, "AlbAccessLogs", {
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      enforceSSL: true,
      versioned: true,
      lifecycleRules: [{ expiration: cdk.Duration.days(30) }],
      removalPolicy: props.productionReady
        ? cdk.RemovalPolicy.RETAIN
        : cdk.RemovalPolicy.DESTROY,
      autoDeleteObjects: !props.productionReady,
    });

    const alb = new elbv2.ApplicationLoadBalancer(this, "Alb", {
      vpc: this.vpc,
      internetFacing: true,
      securityGroup: albSecurityGroup,
      vpcSubnets: { subnetType: ec2.SubnetType.PUBLIC },
    });
    alb.logAccessLogs(accessLogsBucket);

    alb.addListener("HttpRedirect", {
      port: 80,
      defaultAction: elbv2.ListenerAction.redirect({
        protocol: "HTTPS",
        port: "443",
        permanent: true,
      }),
    });

    this.listener = alb.addListener("Https", {
      port: 443,
      certificates: [elbv2.ListenerCertificate.fromArn(props.certificateArn)],
      defaultAction: elbv2.ListenerAction.fixedResponse(404, {
        contentType: "text/plain",
        messageBody: "not found",
      }),
    });

    this.apiRepository = new ecr.Repository(this, "ApiRepository", {
      repositoryName: `neast-api-${props.envName}`,
      imageScanOnPush: true,
      lifecycleRules: [{ maxImageCount: 10 }],
    });
    this.landingRepository = new ecr.Repository(this, "LandingRepository", {
      repositoryName: `neast-landing-${props.envName}`,
      imageScanOnPush: true,
      lifecycleRules: [{ maxImageCount: 10 }],
    });

    new ssm.StringParameter(this, "AlbDnsParam", {
      parameterName: `/neast/${props.envName}/alb/dns-name`,
      stringValue: alb.loadBalancerDnsName,
    });
    new ssm.StringParameter(this, "EcrApiRepositoryUriParam", {
      parameterName: `/neast/${props.envName}/ecr/api-repository-uri`,
      stringValue: this.apiRepository.repositoryUri,
    });
    new ssm.StringParameter(this, "EcrLandingRepositoryUriParam", {
      parameterName: `/neast/${props.envName}/ecr/landing-repository-uri`,
      stringValue: this.landingRepository.repositoryUri,
    });
  }
}
