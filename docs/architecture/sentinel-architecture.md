# SENTINEL Architecture

## Overview

SENTINEL is designed around a security-first cloud platform model.

Rather than treating security as a final review step, the platform integrates security controls throughout the infrastructure lifecycle:

~~~text
Design
  ↓
Terraform
  ↓
Policy Validation
  ↓
Federated CI Identity
  ↓
Cloud Infrastructure
  ↓
Workload Security
  ↓
Audit Evidence
  ↓
Compliance Traceability
~~~

---

## Control Layers

### Layer 1 — Source Control

GitHub provides the authoritative source for:

- Terraform
- Kubernetes manifests
- OPA/Rego policies
- Tests
- CI workflow definitions
- Evidence mappings
- Documentation

---

### Layer 2 — CI Security Gate

GitHub Actions performs preventive validation before infrastructure changes are accepted.

~~~mermaid
flowchart LR
    G[GitHub Change] --> O[OPA/Rego]
    G --> T[Terraform Validation]
    O --> P[Policy Gate]
    T --> P
    P --> F[Federated Terraform Plan]
~~~

The gate validates both infrastructure syntax and security intent.

---

### Layer 3 — Federated CI Identity

GitHub Actions does not use a downloaded Google service account key.

~~~mermaid
flowchart LR
    GH[GitHub Actions] --> OIDC[GitHub OIDC Token]
    OIDC --> WIP[GCP Workload Identity Pool]
    WIP --> PROVIDER[GitHub Provider]
    PROVIDER --> SA[sentinel-github-deploy]
    SA --> GCP[GCP APIs]
~~~

Trust conditions restrict federation to the expected repository and branch.

---

## GCP Landing Zone

~~~mermaid
flowchart TD
    GCP[GCP Project] --> VPC[Custom VPC]
    VPC --> SUBNET[Private Subnet]

    SUBNET --> PODS[Pod Secondary Range]
    SUBNET --> SERVICES[Service Secondary Range]

    GCP --> IAM[IAM Baseline]
    GCP --> LOG[Logging Baseline]
    GCP --> SEC[Security Baseline]

    VPC --> GKE[Regional GKE]
    IAM --> GKE

    GKE --> WI[Workload Identity]
    GKE --> NP[NetworkPolicy]
    GKE --> BA[Binary Authorization]
~~~

---

## Identity Model

SENTINEL separates infrastructure identities based on responsibility.

~~~text
GitHub Actions
    |
    | short-lived federated credential
    v
sentinel-github-deploy
    |
    | Terraform read / plan permissions
    v
Google Cloud

GKE Node Pool
    |
    v
sentinel-gke-node
    |
    | minimal node permissions
    v
Google Cloud APIs

Kubernetes Pod
    |
    v
Kubernetes ServiceAccount
    |
    | Workload Identity Federation
    v
Authorized Google Cloud Resource
~~~

This limits the blast radius of any individual identity.

---

## Network Architecture

~~~text
sentinel-dev VPC
|
+-- sentinel-dev-private
    |
    +-- Primary CIDR
    |   10.20.0.0/20
    |
    +-- Pod secondary range
    |   10.24.0.0/20
    |
    +-- Service secondary range
        10.28.0.0/24
~~~

Security capabilities include:

- Custom-mode VPC
- Explicit subnet design
- Private Google Access
- VPC flow logging
- Kubernetes Dataplane V2
- Kubernetes NetworkPolicy

---

## Kubernetes Security

The GKE environment demonstrates several defense-in-depth controls.

### Node Identity

Worker nodes use a dedicated service account instead of relying on the default Compute Engine identity.

### Workload Identity

Pods authenticate using federated Kubernetes identity rather than static JSON keys.

### Network Segmentation

NetworkPolicy controls permitted pod-to-pod communication.

### Binary Authorization

The GKE cluster is integrated with the project's Binary Authorization policy.

These controls operate at different layers rather than depending on a single security mechanism.

---

## Logging Architecture

Selective Data Access audit logging is enabled for security-relevant services.

~~~text
Cloud Storage
IAM
Secret Manager
GKE
     |
     v
Google Cloud Audit Logs
     |
     v
Cloud Logging
     |
     v
Security Evidence
~~~

Selective enablement provides audit visibility while accounting for the cost implications of high-volume Data Access logs.

---

## Policy Architecture

OPA evaluates the Terraform plan representation.

~~~mermaid
flowchart LR
    TF[Terraform Configuration] --> PLAN[Terraform Plan]
    PLAN --> JSON[Plan JSON]
    JSON --> OPA[OPA / Rego]
    OPA --> IAM[IAM Policy]
    OPA --> STORAGE[Storage Policy]
    OPA --> META[Metadata Policy]
    IAM --> RESULT[Allow / Deny]
    STORAGE --> RESULT
    META --> RESULT
~~~

Examples of denied configurations include:

- Primitive GCP IAM roles
- Broad AWS IAM policies
- Public GCS access
- Public S3 access
- Missing required metadata

---

## Evidence Architecture

SENTINEL treats evidence as an engineering output.

~~~mermaid
flowchart TD
    IAM[IAM Evidence] --> GEN[Evidence Generator]
    LOG[Logging Evidence] --> GEN
    GKE[GKE Evidence] --> GEN
    NET[Network Evidence] --> GEN
    SEC[Security Evidence] --> GEN
    OPA[OPA Test Evidence] --> GEN

    GEN --> HASH[SHA-256 Integrity]
    GEN --> MANIFEST[manifest.json]
    GEN --> REPORT[Security Evidence Report]

    REPORT --> N53[NIST 800-53]
    REPORT --> N171[NIST 800-171]
    REPORT --> CMMC[CMMC]
    REPORT --> CIS[CIS-aligned Categories]
~~~

The generator also records the Git commit so evidence can be associated with a specific source-code state.

---

## Security Engineering Model

SENTINEL demonstrates three complementary control types.

### Preventive

Examples:

- OPA policy gates
- Least-privilege IAM
- NetworkPolicy
- Binary Authorization
- Public-access controls

### Detective

Examples:

- Cloud Audit Logs
- VPC Flow Logs
- CI test results
- Terraform drift detection

### Evidentiary

Examples:

- Captured configuration output
- Generated evidence manifest
- SHA-256 evidence hashes
- Framework mappings
- Git commit traceability

Together these create a repeatable security-engineering lifecycle:

~~~text
Prevent
   ↓
Validate
   ↓
Deploy
   ↓
Observe
   ↓
Collect Evidence
   ↓
Map Controls
   ↓
Improve
~~~

---

## Multi-Cloud Direction

The working implementation is currently GCP-first.

AWS already contains foundational Terraform and identity patterns and is represented in the shared OPA policies. Future parity can extend the same SENTINEL model to:

- AWS VPC
- AWS IAM baselines
- CloudTrail / security logging
- EKS
- IRSA / Pod Identity
- AWS-native security services
- Shared compliance evidence

The architectural objective is not to make AWS and GCP identical. It is to apply the same security principles using the appropriate native controls for each cloud.
