import * as cdk from "aws-cdk-lib";
import * as ecs from "aws-cdk-lib/aws-ecs";
import * as iam from "aws-cdk-lib/aws-iam";
import * as lambda from "aws-cdk-lib/aws-lambda";
import * as rds from "aws-cdk-lib/aws-rds";
import * as scheduler from "aws-cdk-lib/aws-scheduler";
import { Construct } from "constructs";

export interface NightStopStackProps extends cdk.StackProps {
  envName: string;
  productionReady: boolean;
  cluster: ecs.ICluster;
  services: ecs.FargateService[];
  dbInstance: rds.IDatabaseInstance;
  enabled: boolean;
  stopTime: string;
  startTime: string;
}

/**
 * Nightly cost saver: EventBridge Scheduler (Asia/Kuala_Lumpur) invokes a
 * small Lambda that sets ECS desired counts to 0/1 and stops/starts the RDS
 * instance. When disabled, only the start schedule is created so a stopped
 * fleet still comes up in the morning.
 */
export class NightStopStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: NightStopStackProps) {
    super(scope, id, props);

    const fn = new lambda.Function(this, "NightStopFn", {
      runtime: lambda.Runtime.NODEJS_22_X,
      handler: "index.handler",
      timeout: cdk.Duration.minutes(2),
      environment: {
        CLUSTER_NAME: props.cluster.clusterName,
        SERVICE_NAMES: props.services.map((s) => s.serviceName).join(","),
        DB_INSTANCE_ID: props.dbInstance.instanceIdentifier,
      },
      code: lambda.Code.fromInline(`
const { ECSClient, UpdateServiceCommand } = require("@aws-sdk/client-ecs");
const { RDSClient, StopDBInstanceCommand, StartDBInstanceCommand } = require("@aws-sdk/client-rds");

exports.handler = async (event) => {
  const ecs = new ECSClient({});
  const rds = new RDSClient({});
  const cluster = process.env.CLUSTER_NAME;
  const services = process.env.SERVICE_NAMES.split(",");
  const db = process.env.DB_INSTANCE_ID;

  if (event.action === "stop") {
    for (const service of services) {
      await ecs.send(new UpdateServiceCommand({ cluster, service, desiredCount: 0 }));
    }
    await rds.send(new StopDBInstanceCommand({ DBInstanceIdentifier: db }));
    return { stopped: services.length, db };
  }

  await rds.send(new StartDBInstanceCommand({ DBInstanceIdentifier: db }));
  for (const service of services) {
    await ecs.send(new UpdateServiceCommand({ cluster, service, desiredCount: 1 }));
  }
  return { started: services.length, db };
};
`),
    });

    fn.addToRolePolicy(
      new iam.PolicyStatement({
        actions: ["ecs:UpdateService"],
        resources: props.services.map((s) => s.serviceArn),
      }),
    );
    fn.addToRolePolicy(
      new iam.PolicyStatement({
        actions: ["rds:StopDBInstance", "rds:StartDBInstance"],
        resources: [
          `arn:aws:rds:${this.region}:${this.account}:db:${props.dbInstance.instanceIdentifier}`,
        ],
      }),
    );

    const schedulerRole = new iam.Role(this, "SchedulerRole", {
      assumedBy: new iam.ServicePrincipal("scheduler.amazonaws.com"),
    });
    fn.grantInvoke(schedulerRole);

    const cronFor = (hhmm: string): string => {
      const [h, m] = hhmm.split(":").map((p) => Number.parseInt(p, 10));
      return `cron(${m} ${h} * * ? *)`;
    };

    if (props.enabled) {
      new scheduler.CfnSchedule(this, "StopSchedule", {
        name: `neast-${props.envName}-night-stop`,
        scheduleExpression: cronFor(props.stopTime),
        scheduleExpressionTimezone: "Asia/Kuala_Lumpur",
        flexibleTimeWindow: { mode: "OFF" },
        target: {
          arn: fn.functionArn,
          roleArn: schedulerRole.roleArn,
          input: JSON.stringify({ action: "stop" }),
        },
      });
    }

    new scheduler.CfnSchedule(this, "StartSchedule", {
      name: `neast-${props.envName}-night-start`,
      scheduleExpression: cronFor(props.startTime),
      scheduleExpressionTimezone: "Asia/Kuala_Lumpur",
      flexibleTimeWindow: { mode: "OFF" },
      target: {
        arn: fn.functionArn,
        roleArn: schedulerRole.roleArn,
        input: JSON.stringify({ action: "start" }),
      },
    });

    // The Night Stop workflow reads these outputs to resolve current config.
    new cdk.CfnOutput(this, "NightStopEnabled", {
      value: String(props.enabled),
    });
    new cdk.CfnOutput(this, "NightStopTime", { value: props.stopTime });
    new cdk.CfnOutput(this, "NightStartTime", { value: props.startTime });
  }
}
