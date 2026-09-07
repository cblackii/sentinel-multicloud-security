# Checkpoint 3 — Multi-Cloud Identity Federation

## Objective

Establish a reusable identity foundation that allows approved GitHub Actions workflows to authenticate to AWS and Google Cloud using short-lived federated credentials instead of long-lived cloud access keys.

The trust boundary is intentionally restricted to:

- GitHub repository owner: `cblackii`
- Repository: `sentinel-multicloud-security`
- Branch: `main`

## Architecture

~~~text
                         GitHub Actions
                               |
                               | OIDC token
                    +----------+----------+
                    |                     |
                    v                     v
                   AWS                   GCP
                    |                     |
             IAM OIDC Provider     Workload Identity Pool
                    |                     |
             IAM Trust Policy      Workload Identity Provider
                    |                     |
                    v                     v
          SENTINEL GitHub Role     SENTINEL Service Account
                    |                     |
                    +----------+----------+
                               |
                               v
                     Short-Lived Credentials
~~~

## AWS Implementation

A reusable Terraform module was created at:

~~~text
modules/aws/github-oidc/
~~~

The module creates:

- an AWS IAM OpenID Connect provider for GitHub Actions
- an IAM role intended for GitHub Actions federation
- a trust policy using `sts:AssumeRoleWithWebIdentity`

The trust policy validates:

- GitHub OIDC issuer
- audience of `sts.amazonaws.com`
- exact repository identity
- exact `main` branch reference

The initial IAM role intentionally has:

- no managed policies
- no inline workload policies

Additional permissions will be granted only when later SENTINEL capabilities require them.

## GCP Implementation

A reusable Terraform module was created at:

~~~text
modules/gcp/github-wif/
~~~

The module creates:

- a Workload Identity Pool
- a GitHub OIDC Workload Identity Provider
- a dedicated GitHub deployment service account
- an IAM binding allowing approved federated identities to impersonate the service account

The provider maps GitHub claims including:

- subject
- actor
- repository
- repository owner
- Git reference

The attribute condition restricts federation to the approved SENTINEL repository and `main` branch.

The service account has no user-managed service-account keys.

## Security Decisions

### No Static CI/CD Credentials

SENTINEL does not use:

- AWS access keys in GitHub Secrets
- GCP service-account JSON keys
- long-lived CI/CD cloud credentials

The intended authentication model is:

~~~text
GitHub OIDC
    |
    v
Federated Cloud Trust
    |
    v
Short-Lived Credentials
~~~

### Separate Trust and Permissions

Checkpoint 3 establishes who may assume the cloud identities.

It does not grant broad deployment permissions.

This separates:

1. **Trust policy** — who may become the identity
2. **Permissions policy** — what that identity may do

Future checkpoints will add only the permissions required by specific infrastructure modules.

## Validation

Terraform initialization and validation completed successfully for both environment roots.

AWS plan:

~~~text
2 to add
0 to change
0 to destroy
~~~

GCP plan:

~~~text
4 to add
0 to change
0 to destroy
~~~

The reviewed saved plans were applied successfully.

AWS deployment result:

~~~text
2 added
0 changed
0 destroyed
~~~

GCP deployment result:

~~~text
4 added
0 changed
0 destroyed
~~~

## Post-Deployment Verification

AWS verification confirmed:

- GitHub OIDC provider exists
- expected STS audience is configured
- role trust policy is restricted to the SENTINEL repository and `main`
- no managed policies are attached to the role
- no inline policies are attached to the role

GCP verification confirmed:

- Workload Identity Pool is active
- GitHub Workload Identity Provider is active
- GitHub issuer is configured
- repository and branch restrictions are enforced through the provider condition
- no user-managed service-account keys exist

## Terraform State Hygiene

Terraform runtime artifacts remain local and are excluded from Git.

Ignored artifacts include:

- `.terraform/`
- `terraform.tfstate`
- `*.tfstate.*`
- `*.tfplan`

Repository verification confirmed that no Terraform runtime state, plan, or `.terraform/` artifacts are tracked by Git.

Remote state architecture will be addressed before SENTINEL reaches a production-like shared deployment workflow.

## Current State

Checkpoint 3 identity federation foundation is deployed and verified.

GitHub Actions is not yet consuming these identities.

Actual workflow federation and negative authentication tests will be implemented when the CI/CD pipeline is introduced in a later checkpoint.

## Next Checkpoint

**Checkpoint 4 — Secure Multi-Cloud Networking**

The next phase will introduce reusable secure networking patterns for AWS and GCP while preserving the identity and least-privilege principles established here.
