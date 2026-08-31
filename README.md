# Checkpoint 0 — Project Foundation

## Purpose

SENTINEL is a multi-cloud secure landing zone and policy platform focused on secure-by-default Terraform patterns, preventive policy enforcement, native cloud security controls, compliance traceability, and automated evidence generation across AWS and GCP.

## GCP Sandbox Bootstrap

Completed:

- Installed and authenticated the Google Cloud CLI.
- Created a dedicated GCP project for SENTINEL.
- Established a dedicated local `gcloud` configuration named `sentinel`.
- Set the default GCP region to `us-west1`.
- Linked the project to an active billing account.
- Configured a project-scoped monthly budget of $25.
- Configured budget alerts at 50%, 80%, and 100% of actual spend.
- Enabled the Compute Engine API as part of regional CLI configuration.
- Confirmed no application workloads, VMs, storage resources, or Terraform-managed infrastructure have been deployed yet.

## Security Decisions

- Human access currently uses authenticated `gcloud` user credentials.
- Static service-account keys will not be used for CI/CD.
- GitHub Actions will later use Workload Identity Federation.
- Sensitive identifiers such as billing account IDs, project numbers, email addresses, and Terraform state will not be stored in the public repository.
- Raw evidence will remain private; only redacted portfolio-safe evidence will be published.

## Cost Guardrail

The GCP sandbox has a $25 monthly budget with actual-spend notifications at:

- 50%
- 80%
- 100%

The budget is an alerting control, not an automatic shutdown mechanism.

## Current State

Checkpoint 0 GCP account and sandbox bootstrap is complete.

Next session:

- Verify local development tooling.
- Configure IDE support.
- Establish the repository scaffold.
- Begin Terraform conventions and module structure.

No Terraform infrastructure has been deployed.
