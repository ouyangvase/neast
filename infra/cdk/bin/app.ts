#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import { ApiStack } from "../lib/api-stack";
import { DataStack } from "../lib/data-stack";
import { GitHubOidcStack } from "../lib/github-oidc-stack";
import { LandingStack } from "../lib/landing-stack";
import { NetworkStack } from "../lib/network-stack";
import { NightStopStack } from "../lib/night-stop-stack";

const app = new cdk.App();
const envName = String(app.node.tryGetContext("environment") ?? "prod");
const productionReadyContext = app.node.tryGetContext("productionReady");
const productionReady =
  productionReadyContext === true ||
  productionReadyContext === "true" ||
  envName === "prod";
const deployMode = String(app.node.tryGetContext("deployMode") ?? "full");
const account = process.env.CDK_DEFAULT_ACCOUNT;
const region = process.env.CDK_DEFAULT_REGION ?? "ap-southeast-1";
const env = { account, region };
const prefix = `Neast-${envName}`;

const domainName = String(app.node.tryGetContext("domainName") ?? "neast.my");
const apiSubdomain = String(app.node.tryGetContext("apiSubdomain") ?? "api");
const githubOrg = String(app.node.tryGetContext("githubOrg") ?? "ouyangvase");
const githubRepo = String(app.node.tryGetContext("githubRepo") ?? "neast");
const certificateArn = String(app.node.tryGetContext("certificateArn") ?? "");
const imageTag = String(app.node.tryGetContext("imageTag") ?? "latest");
const nightStopEnabledContext = app.node.tryGetContext("nightStopEnabled");
const nightStopEnabled =
  nightStopEnabledContext === undefined
    ? true
    : nightStopEnabledContext === true || nightStopEnabledContext === "true";
const nightStopTime = String(app.node.tryGetContext("nightStopTime") ?? "02:00");
const nightStartTime = String(app.node.tryGetContext("nightStartTime") ?? "07:00");

const deployOidc = deployMode === "oidc";
const deployApp = !deployOidc;

if (deployOidc) {
  new GitHubOidcStack(app, `${prefix}-GitHubOidc`, {
    env,
    envName,
    productionReady,
    githubOrg,
    githubRepo,
  });
}

if (deployApp) {
  if (!certificateArn || certificateArn.startsWith("REPLACE_")) {
    throw new Error(
      "Pass -c certificateArn=arn:aws:acm:... covering neast.my www.neast.my api.neast.my",
    );
  }

  // Always synthesize every app stack so Network CloudFormation exports stay
  // complete. Workflows still deploy named stacks with --exclusively.
  const network = new NetworkStack(app, `${prefix}-Network`, {
    env,
    envName,
    productionReady,
    domainName,
    certificateArn,
    apiSubdomain,
  });
  const data = new DataStack(app, `${prefix}-Data`, {
    env,
    envName,
    productionReady,
    vpc: network.vpc,
    ecsSecurityGroup: network.ecsSecurityGroup,
  });
  const api = new ApiStack(app, `${prefix}-Api`, {
    env,
    envName,
    productionReady,
    vpc: network.vpc,
    cluster: network.cluster,
    listener: network.listener,
    ecsSecurityGroup: network.ecsSecurityGroup,
    repository: network.apiRepository,
    imageTag,
    hostHeader: `${apiSubdomain}.${domainName}`,
    listenerPriority: 10,
    dbSecret: data.dbSecret,
    dbEndpointAddress: data.instance.dbInstanceEndpointAddress,
    redisHost: data.redisEndpointAddress,
    redisPort: data.redisEndpointPort,
    apiEnvSecret: data.apiEnvSecret,
  });
  const landing = new LandingStack(app, `${prefix}-Landing`, {
    env,
    envName,
    productionReady,
    vpc: network.vpc,
    cluster: network.cluster,
    listener: network.listener,
    ecsSecurityGroup: network.ecsSecurityGroup,
    repository: network.landingRepository,
    imageTag,
    hostHeaders: [domainName, `www.${domainName}`],
    listenerPriority: 40,
  });
  new NightStopStack(app, `${prefix}-NightStop`, {
    env,
    envName,
    productionReady,
    cluster: network.cluster,
    services: [api.service, landing.service],
    dbInstance: data.instance,
    enabled: nightStopEnabled,
    stopTime: nightStopTime,
    startTime: nightStartTime,
  });
}
