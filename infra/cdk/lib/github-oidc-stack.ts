import * as cdk from "aws-cdk-lib";
import * as iam from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

export interface GitHubOidcStackProps extends cdk.StackProps {
  envName: string;
  productionReady: boolean;
  githubOrg: string;
  githubRepo: string;
}

/**
 * GitHub Actions OIDC provider + the role workflows assume. Trust is limited
 * to the neast repo on main and the production environment. Deploy this stack
 * once from a laptop (-c deployMode=oidc), then put the role ARN in GitHub as
 * AWS_ROLE_ARN.
 */
export class GitHubOidcStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: GitHubOidcStackProps) {
    super(scope, id, props);

    const provider = new iam.OpenIdConnectProvider(this, "GitHubOidcProvider", {
      url: "https://token.actions.githubusercontent.com",
      clientIds: ["sts.amazonaws.com"],
    });

    const repo = `${props.githubOrg}/${props.githubRepo}`;

    const role = new iam.Role(this, "GitHubActionsRole", {
      roleName: `Neast-${props.envName}-GitHubActions`,
      assumedBy: new iam.WebIdentityPrincipal(provider.openIdConnectProviderArn, {
        StringEquals: {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
        },
        StringLike: {
          "token.actions.githubusercontent.com:sub": [
            `repo:${repo}:ref:refs/heads/main`,
            `repo:${repo}:environment:production`,
          ],
        },
      }),
      maxSessionDuration: cdk.Duration.hours(2),
    });

    // CDK deploys assume the bootstrap (cdk-hnb659fd-*) roles.
    role.addToPolicy(
      new iam.PolicyStatement({
        actions: ["sts:AssumeRole"],
        resources: [`arn:aws:iam::${this.account}:role/cdk-hnb659fd-*`],
      }),
    );

    // Docker push to the neast ECR repositories.
    role.addToPolicy(
      new iam.PolicyStatement({
        actions: ["ecr:GetAuthorizationToken"],
        resources: ["*"],
      }),
    );
    role.addToPolicy(
      new iam.PolicyStatement({
        actions: [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
        ],
        resources: [
          `arn:aws:ecr:${this.region}:${this.account}:repository/neast-*`,
        ],
      }),
    );

    // Runtime lookups the workflows perform directly (SSM params, stack
    // outputs for night-stop, API env secret preflight).
    role.addToPolicy(
      new iam.PolicyStatement({
        actions: ["ssm:GetParameter"],
        resources: [
          `arn:aws:ssm:${this.region}:${this.account}:parameter/neast/*`,
        ],
      }),
    );
    role.addToPolicy(
      new iam.PolicyStatement({
        actions: ["cloudformation:DescribeStacks", "cloudformation:DeleteStack"],
        resources: [
          `arn:aws:cloudformation:${this.region}:${this.account}:stack/Neast-*/*`,
        ],
      }),
    );
    role.addToPolicy(
      new iam.PolicyStatement({
        actions: ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"],
        resources: [
          `arn:aws:secretsmanager:${this.region}:${this.account}:secret:/neast/*`,
        ],
      }),
    );

    new cdk.CfnOutput(this, "GitHubActionsRoleArn", {
      value: role.roleArn,
      description: "GitHub Environment secret AWS_ROLE_ARN",
    });
  }
}
