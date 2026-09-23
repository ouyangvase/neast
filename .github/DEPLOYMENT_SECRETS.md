# NEAST GitHub Actions — secrets and bootstrap

Phase 1 is **production only**. Staging workflow files exist but are disabled
(`workflow_dispatch` only and they fail on purpose until staging AWS exists).
Do not create a GitHub Environment named `staging` yet.

GitHub repo: `ouyangvase/neast`
AWS: account `548890973567`, region `ap-southeast-1`, local CLI profile `brunei-market`
Hosts: `neast.my`, `www.neast.my`, `api.neast.my`
Apps: `apps/neast-user` (`com.neastusers.flutter`), `apps/neast-merchant`
(`com.neastMerchant.flutter`), `apps/neast-owner` (`com.neastLandlords.flutter`)

---

## 0. Order of operations

Do these in order. Store sections (3–5) can run in parallel with AWS.

1. **AWS**: ACM certificate → CDK bootstrap → `Neast-prod-GitHubOidc` → `AWS_ROLE_ARN`.
2. **GitHub**: create Environment `production`, add AWS secrets.
3. **First deploy**: run **Deploy Prod API** (creates Network + Data, then fails
   the env-secret preflight — expected), fill `/neast/prod/api/env`, re-run.
   Then **Deploy Prod Landing**. Verify both through the ALB before any DNS change.
4. **Seed the RDS schema** through an SSM port-forward (section 2.5).
5. **Apple** (section 3): bundle IDs, App Store Connect records, API key, match repo.
6. **Google** (section 4): Play Console apps, upload service account.
7. **Android keystore** (section 5).
8. **Store workflows**: TestFlight / Play Internal smoke runs.
9. **DNS cutover last** (section 6): `api.neast.my` is the LIVE old system —
   only repoint it when the new stack is verified.

---

## 1. GitHub — Environments and secrets

Repo **Settings → Environments → New environment** → name it `production`.
Add these secrets on that environment (not only at repository level), because
the deploy jobs set `environment: production`.

| Secret | Used by | Where to get it |
|---|---|---|
| `AWS_ROLE_ARN` | all AWS deploys | CDK output `GitHubActionsRoleArn` (section 2.3) |
| `ACM_CERTIFICATE_ARN` | all AWS deploys | ACM cert covering neast.my, www, api (section 2.2) |
| `ASC_APP_ID_USER` | iOS App Store submit (user) | App Store Connect numeric Apple ID (section 3.2) |
| `ASC_APP_ID_MERCHANT` | iOS App Store submit (merchant) | App Store Connect numeric Apple ID (section 3.2) |
| `ASC_APP_ID_OWNER` | iOS App Store submit (owner) | App Store Connect numeric Apple ID (section 3.2) |
| `ASC_TEAM_ID` | iOS build + submit | Apple Developer Team ID `9LNX82S688` (section 3.3) |
| `ASC_API_KEY_ID` | iOS build + submit | App Store Connect API key (section 3.4) |
| `ASC_API_KEY_ISSUER_ID` | iOS build + submit | App Store Connect Issuer ID (section 3.4) |
| `ASC_API_KEY_P8` | iOS build + submit | Full `.p8` contents incl. `BEGIN PRIVATE KEY` (section 3.4) |
| `MATCH_PASSWORD` | iOS signing | You choose it; decrypts the certs repo (section 3.5) |
| `MATCH_GIT_BASIC_AUTHORIZATION` | iOS signing | base64 `user:PAT` for the certs repo (section 3.5) |
| `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | Android deploy | Play Console upload service account JSON (section 4.3) |
| `ANDROID_KEYSTORE_BASE64` | Android build | base64 of the upload keystore (section 5) |
| `KEYSTORE_PASSWORD` | Android build | You choose it at keystore creation (section 5) |
| `KEY_ALIAS` | Android build | Keystore alias, e.g. `neast-upload` (section 5) |
| `KEY_PASSWORD` | Android build | You choose it at keystore creation (section 5) |

Repository-level copies of the same secrets also work, but Environment secrets
override them for jobs that set `environment: production`.

Do **not** put `DB_PASSWORD`, Fiuu keys, or Firebase credentials in GitHub.
Those live in Secrets Manager (`/neast/prod/api/env`) and ECS injects them.

---

## 2. AWS — account, cert, OIDC, first deploy

All commands use the local profile `brunei-market` (account `548890973567`).

```bash
aws sts get-caller-identity --profile brunei-market --region ap-southeast-1
```

### 2.1 ACM certificate (ALB TLS)

The ALB terminates TLS, so it needs a public ACM cert in **ap-southeast-1**
(not us-east-1).

```bash
aws acm request-certificate \
  --profile brunei-market --region ap-southeast-1 \
  --domain-name neast.my \
  --subject-alternative-names www.neast.my api.neast.my \
  --validation-method DNS
```

Copy the returned `CertificateArn` → GitHub secret `ACM_CERTIFICATE_ARN`.

Get the validation records:

```bash
aws acm describe-certificate \
  --profile brunei-market --region ap-southeast-1 \
  --certificate-arn "$CERT_ARN" \
  --query 'Certificate.DomainValidationOptions[].ResourceRecord'
```

Create each validation CNAME wherever `neast.my` DNS is currently hosted
(Cloudflare / Route 53 / registrar DNS). These records only prove ownership —
they do not move traffic. Wait until `describe-certificate` shows
`"Status": "ISSUED"`.

### 2.2 CDK bootstrap

One-time per account/region:

```bash
cd infra/cdk
npm ci
ACCOUNT=$(aws sts get-caller-identity --profile brunei-market --query Account --output text)
npx cdk bootstrap "aws://${ACCOUNT}/ap-southeast-1" --profile brunei-market
```

### 2.3 GitHub OIDC role

```bash
AWS_PROFILE=brunei-market npx cdk deploy Neast-prod-GitHubOidc \
  --require-approval never \
  -c environment=prod \
  -c deployMode=oidc \
  -c productionReady=true
```

Copy stack output `GitHubActionsRoleArn` → GitHub secret `AWS_ROLE_ARN`.

OIDC trust is limited to repo `ouyangvase/neast`, branch `main`, and
environment `production`.

### 2.4 First deploy + API env secret

1. In GitHub → Actions, run **Deploy Prod API** (workflow_dispatch). It creates
   `Neast-prod-Network` + `Neast-prod-Data` (RDS takes ~10 min), then fails at
   the **Preflight API env secret** step. Expected.
2. Fill the API env secret. Keys (see `services/neast-api/.env.example`):

```bash
aws secretsmanager put-secret-value \
  --profile brunei-market --region ap-southeast-1 \
  --secret-id /neast/prod/api/env \
  --secret-string '{
    "FIUU_MERCHANT_ID": "...",
    "FIUU_VERIFY_KEY": "...",
    "FIUU_SECRET_KEY": "...",
    "FIUU_CURRENCY": "MYR",
    "FIUU_COUNTRY": "MY",
    "PAYMENT_H5_BASE_URL": "https://api.neast.my",
    "REFERR_INVITE_URL": "https://api.neast.my/invite",
    "MERCHANT_SHARE_BASE_URL": "https://api.neast.my/merchant-share",
    "APP_STORE_URL": "",
    "GOOGLE_PLAY_URL": "",
    "OWNER_APP_STORE_URL": "",
    "OWNER_GOOGLE_PLAY_URL": "",
    "MERCHANT_APP_STORE_URL": "",
    "MERCHANT_GOOGLE_PLAY_URL": "",
    "FIREBASE_CREDENTIALS": "<full firebase service-account JSON as one line>",
    "SHOW_ALPHA_NOTICE_USER": "0",
    "SHOW_ALPHA_NOTICE_MERCHANT": "0",
    "SHOW_ALPHA_NOTICE_LANDLORD": "0"
  }'
```

Every key must exist — ECS fails to start the task if a referenced key is
missing. Leave store URLs empty until section 6/7, then update them.

3. Re-run **Deploy Prod API**. It builds `services/neast-api/Dockerfile`,
   pushes to ECR `neast-api-prod`, deploys `Neast-prod-Api`, and waits on the
   health check through the ALB (no DNS needed yet).
4. Run **Deploy Prod Landing** the same way.

### 2.5 Seed the RDS schema (one time)

RDS is private. Tunnel through the API task with Session Manager (needs the
[Session Manager plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)):

```bash
RDS_HOST=$(aws ssm get-parameter --profile brunei-market --region ap-southeast-1 --name /neast/prod/rds/endpoint --query Parameter.Value --output text)
SVC=$(aws ecs list-services --profile brunei-market --region ap-southeast-1 --cluster neast-prod --query 'serviceArns[0]' --output text | awk -F/ '{print $NF}')
TASK=$(aws ecs list-tasks --profile brunei-market --region ap-southeast-1 --cluster neast-prod --service-name "$SVC" --query 'taskArns[0]' --output text | awk -F/ '{print $NF}')
RUNTIME=$(aws ecs describe-tasks --profile brunei-market --region ap-southeast-1 --cluster neast-prod --tasks "$TASK" --query 'tasks[0].containers[?name==`api`].runtimeId' --output text)

aws ssm start-session --profile brunei-market --region ap-southeast-1 \
  --target "ecs:neast-prod_${TASK}_${RUNTIME}" \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "{\"host\":[\"$RDS_HOST\"],\"portNumber\":[\"3306\"],\"localPortNumber\":[\"3307\"]}"
```

In a second terminal (password from
`aws secretsmanager get-secret-value --secret-id /neast/prod/rds/credentials`):

```bash
for f in services/neast-api/sql/*.sql; do
  mysql -h 127.0.0.1 -P 3307 -u admin -p neast < "$f"
done
```

### 2.6 Values to read after the first Network deploy

```bash
aws ssm get-parameter --profile brunei-market --region ap-southeast-1 --name /neast/prod/alb/dns-name --query Parameter.Value --output text
aws ssm get-parameter --profile brunei-market --region ap-southeast-1 --name /neast/prod/api/url --query Parameter.Value --output text
aws ssm get-parameter --profile brunei-market --region ap-southeast-1 --name /neast/prod/landing/url --query Parameter.Value --output text
```

The ALB DNS name is the CNAME **target** for the DNS cutover (section 6).

Verify through the ALB before touching DNS:

```bash
ALB=$(aws ssm get-parameter --profile brunei-market --region ap-southeast-1 --name /neast/prod/alb/dns-name --query Parameter.Value --output text)
curl -sf --connect-to api.neast.my:443:${ALB}:443 https://api.neast.my/health
curl -sf --connect-to www.neast.my:443:${ALB}:443 https://www.neast.my/
```

---

## 3. Apple Developer + App Store Connect

### 3.1 Bundle IDs (Apple Developer portal)

https://developer.apple.com/account/resources/identifiers → **+** → App IDs,
once per app:

| App | Bundle ID | Notes |
|---|---|---|
| NEAST User | `com.neastusers.flutter` | enable Push Notifications |
| NEAST Merchant | `com.neastMerchant.flutter` | enable Push Notifications |
| NEAST Owner | `com.neastLandlords.flutter` | enable Push Notifications |

(Capabilities must match what each app already uses — check
`ios/Runner/Runner.entitlements` / Xcode project if unsure.)

### 3.2 App records (App Store Connect)

https://appstoreconnect.apple.com → **Apps → + → New App**, once per app.
Bundle ID must already exist (3.1). Pick any SKU (e.g. `neast-user-ios`).

For each app: open it → **App Information** → copy the numeric **Apple ID**:

| App | GitHub secret |
|---|---|
| NEAST User | `ASC_APP_ID_USER` |
| NEAST Merchant | `ASC_APP_ID_MERCHANT` |
| NEAST Owner | `ASC_APP_ID_OWNER` |

### 3.3 Team ID

https://developer.apple.com/account → **Membership details** → **Team ID**
(the Xcode projects already reference `9LNX82S688`). → GitHub secret
`ASC_TEAM_ID`.

### 3.4 App Store Connect API key

App Store Connect → **Users and Access → Integrations → App Store Connect API
→ Team Keys → Generate API Key**.

- Access: **Admin** (needed to submit for review) or at least App Manager.
- Download the `.p8` **once** — Apple will not show it again.
- GitHub secrets: `ASC_API_KEY_ID` = Key ID, `ASC_API_KEY_ISSUER_ID` = Issuer
  ID, `ASC_API_KEY_P8` = full file contents.

### 3.5 iOS signing — fastlane match

CI signs with **match** from a dedicated private certs repo.

1. Create a **private** GitHub repo `ouyangvase/neast-ios-certs` (empty).
2. Create a GitHub PAT (Settings → Developer settings → Fine-grained tokens)
   with **Contents: Read and write** on `neast-ios-certs` only.
3. `MATCH_GIT_BASIC_AUTHORIZATION` = `echo -n "your-github-username:THE_PAT" | base64`.
4. Choose a strong passphrase → `MATCH_PASSWORD`.
5. Seed certificates/profiles once per app from your Mac (needs the ASC API
   key from 3.4):

```bash
cd apps/neast-user/ios   # then neast-merchant/ios, neast-owner/ios
export ASC_API_KEY_ID=... ASC_API_KEY_ISSUER_ID=... ASC_API_KEY_P8="$(cat /path/AuthKey.p8)"
export MATCH_PASSWORD=... MATCH_GIT_BASIC_AUTHORIZATION=...
gem install fastlane
fastlane match appstore --api_key_path <(echo "{\"key_id\":\"$ASC_API_KEY_ID\",\"issuer_id\":\"$ASC_API_KEY_ISSUER_ID\",\"key\":\"$ASC_API_KEY_P8\"}")
```

(match creates one shared "Apple Distribution" cert + one App Store profile
per bundle ID in the certs repo. CI runs match in `readonly` mode.)

### 3.6 First version checklist (per app, manual)

Create the first iOS version in App Store Connect and fill: privacy policy
URL, category, screenshots (required sizes), age rating, review contact +
demo account. `ITSAppUsesNonExemptEncryption=false` is already set in each
`ios/Runner/Info.plist`, so no encryption prompt blocks CI.

The `submit_review` lane only **submits the already-uploaded build** and sets
What's New. It does not upload screenshots or metadata.

---

## 4. Google Play Console

https://play.google.com/console

### 4.1 Create the apps

Create three apps with the exact package names:

| App | Package name |
|---|---|
| NEAST User | `com.neastusers.flutter` |
| NEAST Merchant | `com.neastMerchant.flutter` |
| NEAST Owner | `com.neastLandlords.flutter` |

Package names cannot change later. Fill store listing, content rating, and
add an **internal testing** testers list per app — the workflow only uploads
the AAB.

### 4.2 Enable the Play Developer API

Play Console → **Setup → API access** → link a Google Cloud project (or create
one) → in Google Cloud Console enable **Google Play Android Developer API**.

### 4.3 Upload service account

Play Console → **Setup → API access → Service accounts → Create** (jumps to
Google Cloud Console) → create service account + JSON key. Back in Play
Console, **grant access** to all three apps with **Release manager** (or a
role that can upload to internal testing).

Put the **full JSON file contents** in GitHub secret
`GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`.

Note: if the first API upload fails with "application not found" / permission
errors on a brand-new app, upload the first AAB once manually in Play Console
(**Testing → Internal testing → Create release**), then CI takes over.

---

## 5. Android upload keystore

One keystore signs all three apps. Generate once, keep the file offline too:

```bash
keytool -genkeypair -v -keystore upload.keystore \
  -alias neast-upload -keyalg RSA -keysize 2048 -validity 10950
base64 -i upload.keystore | pbcopy   # paste into GitHub secret ANDROID_KEYSTORE_BASE64
```

GitHub secrets: `ANDROID_KEYSTORE_BASE64` (the base64), `KEYSTORE_PASSWORD`,
`KEY_ALIAS` (`neast-upload`), `KEY_PASSWORD`.

Each app's `android/app/build.gradle.kts` already reads
`android/key.properties` (gitignored); CI writes it from these secrets.

Enroll each Play app in **Play App Signing** (Play Console → Setup → App
integrity) on the first upload — Google keeps the real signing key, the
keystore above becomes the upload key.

---

## 6. DNS cutover (do LAST)

`api.neast.my` currently serves the **old live system**. Repointing it moves
production traffic to the new stack. Only do this after sections 2–5 verify
green through the ALB (section 2.6).

Wherever `neast.my` DNS is hosted, create CNAMEs to the ALB DNS name
(`/neast/prod/alb/dns-name`):

| Name | Type | Target |
|---|---|---|
| `@` (apex) | CNAME / ALIAS / flattening | `$ALB` |
| `www` | CNAME | `$ALB` |
| `api` | CNAME | `$ALB` |

Keep the ACM validation CNAMEs from 2.1 in place.

If the provider is Cloudflare: SSL/TLS mode **Full (strict)**, records may be
proxied (orange cloud). If it is Route 53: use alias A/AAAA records to the ALB
instead of CNAMEs for the apex.

After cutover:

```bash
curl -sf https://api.neast.my/health
curl -sf https://www.neast.my/
```

Then update the store URLs in `/neast/prod/api/env` (section 2.4) once the
store listings exist, and roll the API (re-run **Deploy Prod API**).

---

## 7. What this phase does not include

- GitHub Environment `staging` / auto-deploy from `develop`
- Play production track / Play store review (internal track only)
- OTA updates (Flutter has no EAS Update equivalent; Shorebird not adopted)
- S3 uploads (API still writes local disk on the task; files are lost on replace)
- NAT gateways (ECS tasks use public IPs; RDS/Redis stay private)
- Multi-AZ RDS / Redis replication
