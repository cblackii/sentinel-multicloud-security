# SENTINEL Automated Security Evidence Report

Generated: `2026-10-07T01:40:19.831091+00:00`
Git branch: `main`
Git commit: `c5a2567a82c7cd2c889d9151e97fe2d9266c4fcb`

## Summary

- Evidence artifacts discovered: **21**
- Compliance mapping files discovered: **4**
- Evidence integrity: SHA-256 calculated for every artifact

> These mappings demonstrate security engineering traceability.
> They do not represent a formal compliance certification or assessment.

## Evidence Inventory

| Evidence artifact | SHA-256 |
|---|---|
| `evidence/examples/checkpoint-7-opa-tests.txt` | `0f0f6c1c8221f08e...` |
| `evidence/gcp/gke/network-policy-deny.txt` | `8defe1500e129ef1...` |
| `evidence/gcp/gke/network-policy.txt` | `40f560643ad8b6a5...` |
| `evidence/gcp/gke/nodes.txt` | `f34d41262ee7c5c3...` |
| `evidence/gcp/gke/wif-gcs-access.txt` | `10c53f390571a8ad...` |
| `evidence/gcp/gke/wif-metadata-identity.txt` | `6b02244e9399f10f...` |
| `evidence/gcp/gke/wif-no-static-key.txt` | `ddb92401cd609458...` |
| `evidence/gcp/gke/workloads.txt` | `f8d4e157098b1283...` |
| `evidence/gcp/iam-baseline/default-compute-sa-roles-after.txt` | `e3b0c44298fc1c14...` |
| `evidence/gcp/iam-baseline/gke-instance-identities.txt` | `a67b3786983dcf77...` |
| `evidence/gcp/iam-baseline/node-service-account.txt` | `92262ddd7fa2f8a0...` |
| `evidence/gcp/iam-baseline/nodes-after-hardening.txt` | `69aa9ec2b0ebf2f2...` |
| `evidence/gcp/iam-baseline/wif-after-hardening.txt` | `6b02244e9399f10f...` |
| `evidence/gcp/logging-baseline/audit-configs.txt` | `92faab84d4393ace...` |
| `evidence/gcp/logging-baseline/log-buckets.txt` | `ae4ef32e94042db6...` |
| `evidence/gcp/logging-baseline/log-sinks.txt` | `33bf6ded46506598...` |
| `evidence/gcp/security-baseline/binary-authorization-policy.txt` | `d6306c9a8eee075e...` |
| `evidence/gcp/security-baseline/gke-security-settings.txt` | `c91f15ee9ed28c5e...` |
| `evidence/gcp/security-baseline/nodes.txt` | `6de02ea093f11f26...` |
| `evidence/gcp/security-baseline/security-apis.txt` | `bd1f56c58e7b9df6...` |
| `evidence/gcp/security-baseline/workloads.txt` | `aefae370dbb5cff8...` |

## Framework Traceability

### CIS-aligned security categories

Source mapping: `policies/compliance/cis/mapping.json`

#### Identity and Access Management

- **PASS** `evidence/gcp/iam-baseline/node-service-account.txt`
- **PASS** `evidence/gcp/iam-baseline/gke-instance-identities.txt`

#### Logging and Monitoring

- **PASS** `evidence/gcp/logging-baseline/audit-configs.txt`
- **PASS** `evidence/gcp/logging-baseline/log-sinks.txt`
- **PASS** `evidence/gcp/logging-baseline/log-buckets.txt`

#### Kubernetes and Workload Security

- **PASS** `evidence/gcp/security-baseline/gke-security-settings.txt`
- **PASS** `evidence/gcp/security-baseline/binary-authorization-policy.txt`
- **PASS** `evidence/gcp/gke/network-policy.txt`

#### Credential Management

- **PASS** `evidence/gcp/gke/wif-no-static-key.txt`
- **PASS** `evidence/gcp/gke/wif-gcs-access.txt`

### CMMC

Source mapping: `policies/compliance/cmmc/mapping.json`

#### Access Control

- **PASS** `evidence/gcp/iam-baseline/node-service-account.txt`
- **PASS** `evidence/gcp/iam-baseline/default-compute-sa-roles-after.txt`

#### Audit and Accountability

- **PASS** `evidence/gcp/logging-baseline/audit-configs.txt`
- **PASS** `evidence/gcp/logging-baseline/log-buckets.txt`

#### Configuration Management

- **PASS** `evidence/examples/checkpoint-7-opa-tests.txt`
- **PASS** `evidence/gcp/security-baseline/security-apis.txt`

#### Identification and Authentication

- **PASS** `evidence/gcp/gke/wif-no-static-key.txt`
- **PASS** `evidence/gcp/gke/wif-metadata-identity.txt`

#### System and Communications Protection

- **PASS** `evidence/gcp/gke/network-policy.txt`
- **PASS** `evidence/gcp/gke/network-policy-deny.txt`

### NIST SP 800-171

Source mapping: `policies/compliance/nist-800-171/mapping.json`

#### 3.1.5 — Employ least privilege

- **PASS** `evidence/gcp/iam-baseline/node-service-account.txt`
- **PASS** `evidence/gcp/iam-baseline/default-compute-sa-roles-after.txt`

#### 3.3.1 — Create and retain system audit logs

- **PASS** `evidence/gcp/logging-baseline/audit-configs.txt`
- **PASS** `evidence/gcp/logging-baseline/log-buckets.txt`

#### 3.4.1 — Establish and maintain baseline configurations

- **PASS** `evidence/gcp/security-baseline/security-apis.txt`
- **PASS** `evidence/gcp/security-baseline/gke-security-settings.txt`

#### 3.5.3 — Use multifactor or cryptographically protected authentication mechanisms where applicable

- **PASS** `evidence/gcp/gke/wif-metadata-identity.txt`
- **PASS** `evidence/gcp/gke/wif-no-static-key.txt`

#### 3.13.1 — Monitor, control, and protect communications at external and key internal boundaries

- **PASS** `evidence/gcp/gke/network-policy.txt`
- **PASS** `evidence/gcp/gke/network-policy-deny.txt`

### NIST SP 800-53

Source mapping: `policies/compliance/nist-800-53/mapping.json`

#### AC-6 — Least Privilege

Dedicated GKE node identity, removal of broad default compute permissions, federated CI identity.

- **PASS** `evidence/gcp/iam-baseline/node-service-account.txt`
- **PASS** `evidence/gcp/iam-baseline/gke-instance-identities.txt`
- **PASS** `evidence/gcp/iam-baseline/default-compute-sa-roles-after.txt`

#### AU-2 — Event Logging

Selective Google Cloud Data Access audit logging for security-relevant services.

- **PASS** `evidence/gcp/logging-baseline/audit-configs.txt`

#### AU-12 — Audit Record Generation

Cloud Logging audit configuration and managed log buckets.

- **PASS** `evidence/gcp/logging-baseline/audit-configs.txt`
- **PASS** `evidence/gcp/logging-baseline/log-buckets.txt`
- **PASS** `evidence/gcp/logging-baseline/log-sinks.txt`

#### CM-2 — Baseline Configuration

Terraform-managed network, IAM, logging, GKE, and security baselines.

- **PASS** `evidence/gcp/security-baseline/security-apis.txt`
- **PASS** `evidence/gcp/security-baseline/gke-security-settings.txt`

#### CM-3 — Configuration Change Control

GitHub Actions validates Terraform and OPA policy before changes are accepted.

- **PASS** `evidence/examples/checkpoint-7-opa-tests.txt`

#### IA-5 — Authenticator Management

GitHub Actions and Kubernetes workloads use federated identity instead of long-lived static credentials.

- **PASS** `evidence/gcp/gke/wif-no-static-key.txt`
- **PASS** `evidence/gcp/gke/wif-metadata-identity.txt`
- **PASS** `evidence/gcp/gke/wif-gcs-access.txt`

#### SC-7 — Boundary Protection

Custom VPC, private subnet design, Kubernetes NetworkPolicy, and controlled service exposure.

- **PASS** `evidence/gcp/gke/network-policy.txt`
- **PASS** `evidence/gcp/gke/network-policy-deny.txt`

#### SI-7 — Software, Firmware, and Information Integrity

Binary Authorization and policy-as-code controls protect workload and infrastructure integrity.

- **PASS** `evidence/gcp/security-baseline/binary-authorization-policy.txt`
- **PASS** `evidence/examples/checkpoint-7-opa-tests.txt`

