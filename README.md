# SENTINEL — Multi-Cloud Secure Landing Zone & Policy Platform

SENTINEL is a cloud security engineering portfolio project designed to demonstrate how secure cloud foundations can be built, validated, and continuously governed using Infrastructure as Code, workload identity, policy-as-code, automated security controls, and compliance evidence.

The project currently implements a working **Google Cloud security platform** and establishes reusable patterns for AWS expansion.

> The goal is not simply to deploy cloud infrastructure. SENTINEL demonstrates how security controls can be engineered into the cloud platform, validated before deployment, and tied to auditable evidence.

---
## Portfolio Snapshot

| Area | Implementation |
|---|---|
| Cloud Platform | Google Cloud Platform |
| Infrastructure as Code | Terraform |
| Kubernetes | Regional GKE |
| Network Security | Custom VPC, private subnet, VPC-native GKE, NetworkPolicy |
| Identity | Least-privilege service accounts, GitHub OIDC/WIF, GKE Workload Identity |
| Policy as Code | OPA / Rego |
| CI/CD Security | GitHub Actions security gate and federated Terraform planning |
| Supply Chain | Binary Authorization integration |
| Auditability | Selective Cloud Audit Logs and collected security evidence |
| Compliance Traceability | NIST SP 800-53, NIST SP 800-171, CMMC, CIS-aligned mappings |
| Evidence Automation | Python evidence generator with SHA-256 integrity metadata |

**Key outcome:** SENTINEL demonstrates how infrastructure provisioning, identity, Kubernetes security, preventive policy controls, CI/CD enforcement, and compliance evidence can operate as one repeatable cloud security engineering workflow.

**Detailed architecture:** [`docs/architecture/sentinel-architecture.md`](docs/architecture/sentinel-architecture.md)

**Generated security evidence:** [`evidence/generated/security-evidence-report.md`](evidence/generated/security-evidence-report.md)

## Project Goals

SENTINEL demonstrates practical implementation of:

- Secure cloud networking
- Least-privilege IAM
- Keyless workload identity
- Kubernetes workload security
- Cloud audit logging
- Security service enablement
- Policy-as-code with OPA/Rego
- CI/CD security gates
- GitHub-to-GCP federated identity
- Automated Terraform validation
- Automated security evidence generation
- Compliance traceability

---

## Architecture

~~~mermaid
flowchart TD

    DEV[Developer] --> GIT[GitHub Repository]

    GIT --> ACTIONS[GitHub Actions]

    ACTIONS --> OPA[OPA / Rego Policy Gate]
    ACTIONS --> TFV[Terraform Validation]
    ACTIONS --> WIF[GitHub OIDC Federation]

    WIF --> GCP[GCP Workload Identity Federation]

    GCP --> TF[Terraform]

    TF --> VPC[Custom VPC + Private Subnet]
    TF --> IAM[IAM Baseline]
    TF --> LOG[Logging Baseline]
    TF --> SEC[Security Baseline]
    TF --> GKE[Regional GKE Cluster]

    IAM --> NODE[Dedicated GKE Node Service Account]

    GKE --> WI[GKE Workload Identity]
    GKE --> NP[Kubernetes NetworkPolicy]
    GKE --> BA[Binary Authorization]

    LOG --> AUDIT[Selective Data Access Audit Logging]

    SEC --> APIS[Security APIs]

    VPC --> EVIDENCE[Security Evidence]
    IAM --> EVIDENCE
    LOG --> EVIDENCE
    SEC --> EVIDENCE
    GKE --> EVIDENCE

    EVIDENCE --> GEN[Automated Evidence Generator]
    GEN --> REPORT[Security Evidence Report]
    REPORT --> COMP[Compliance Traceability]

    COMP --> CIS[CIS]
    COMP --> CMMC[CMMC]
    COMP --> NIST171[NIST SP 800-171]
    COMP --> NIST53[NIST SP 800-53]
~~~

A more detailed architecture description is available at:

`docs/architecture/sentinel-architecture.md`

---

## Implemented Security Capabilities

### 1. Secure Networking

SENTINEL provisions a custom Google Cloud VPC rather than relying on the default network.

Implemented controls include:

- Custom VPC
- Custom private subnet
- Dedicated GKE Pod CIDR
- Dedicated GKE Service CIDR
- Private Google Access
- VPC Flow Logs
- Controlled Kubernetes service exposure

Example addressing:

~~~text
VPC
└── sentinel-dev
    └── private subnet: 10.20.0.0/20
        ├── GKE Pods:     10.24.0.0/20
        └── GKE Services: 10.28.0.0/24
~~~

---

### 2. IAM Hardening

SENTINEL applies least-privilege identity patterns for both infrastructure and workloads.

Implemented controls include:

- Dedicated GKE node service account
- Removal of broad default Compute Engine Editor permissions
- Scoped GKE node permissions
- Dedicated GitHub deployment identity
- No user-managed service account keys
- Workload Identity Federation
- Read-only CI permissions for Terraform planning

This separates:

~~~text
Human identity
    ↓
CI/CD identity
    ↓
GKE node identity
    ↓
Kubernetes workload identity
~~~

Each identity receives only the permissions required for its function.

---

### 3. GitHub Actions Workload Identity Federation

GitHub Actions authenticates to Google Cloud without storing long-lived JSON service account keys.

~~~text
GitHub Actions
      ↓
GitHub OIDC Token
      ↓
GCP Workload Identity Pool
      ↓
Federated Provider
      ↓
sentinel-github-deploy Service Account
      ↓
Authorized GCP APIs
~~~

Trust is restricted to the approved SENTINEL GitHub repository and `main` branch.

This replaces static CI credentials with short-lived federated credentials.

---

### 4. GKE Security Baseline

SENTINEL provisions a regional Google Kubernetes Engine cluster using Terraform.

Implemented controls include:

- Regional GKE
- VPC-native networking
- Dataplane V2
- Shielded Nodes
- Workload Identity Federation for GKE
- Dedicated node service account
- Metadata server protection
- Binary Authorization integration
- Kubernetes NetworkPolicy

The cluster is connected directly to the custom SENTINEL network and dedicated secondary IP ranges.

---

### 5. GKE Workload Identity

Kubernetes workloads authenticate to Google Cloud APIs without static service account keys.

~~~text
Kubernetes Pod
      ↓
Kubernetes ServiceAccount
      ↓
GKE Metadata Server
      ↓
Workload Identity Federation
      ↓
Google IAM
      ↓
Authorized Google Cloud Resource
~~~

The implementation was validated by allowing a Kubernetes workload to access an authorized Cloud Storage resource without a JSON key.

---

### 6. Kubernetes NetworkPolicy

SENTINEL uses Kubernetes NetworkPolicy to demonstrate workload-level network segmentation.

The project includes both:

- Allowed application communication
- Explicit denied communication testing

This demonstrates that workload communication can be restricted independently from VPC-level firewall controls.

---

### 7. Cloud Audit Logging

The logging baseline enables selective Google Cloud Data Access audit logging for security-sensitive services.

Current services include:

- Cloud Storage
- IAM
- Secret Manager
- Google Kubernetes Engine

This provides increased audit visibility while avoiding unnecessary project-wide Data Access logging costs.

---

### 8. Security Service Baseline

Terraform enables security-related Google Cloud APIs required by the SENTINEL platform.

Examples include:

- Secret Manager
- Cloud KMS
- Container Analysis
- Binary Authorization
- Cloud Resource Manager

This creates a reusable security-service foundation for workloads deployed into the platform.

---

## Policy-as-Code

SENTINEL uses **Open Policy Agent (OPA)** and **Rego** to evaluate Terraform changes before deployment.

Current policy families include:

### Public Storage Protection

Detects insecure storage configurations such as:

- Public Google Cloud Storage access
- Missing GCS Public Access Prevention
- Public Amazon S3 ACLs
- Public S3 bucket policies
- Missing S3 public-access-block controls

### Broad IAM Protection

Detects:

- GCP primitive roles such as `roles/owner`
- GCP primitive roles such as `roles/editor`
- AWS wildcard IAM policies
- AWS AdministratorAccess
- AWS IAMFullAccess
- AWS PowerUserAccess

### Required Metadata

Requires security and governance metadata such as:

~~~text
GCP:
- environment
- managed_by
- project

AWS:
- Environment
- ManagedBy
- Project
~~~

OPA unit tests currently validate both expected allow and deny behavior.

---

## Automated Policy Testing

Policy tests are stored under:

`tests/policies/`

Current OPA test suite validates:

- Public storage denial
- Hardened storage allowance
- Broad IAM denial
- Scoped IAM allowance
- Required metadata enforcement
- Delete-only Terraform change handling

Run locally with:

~~~bash
opa fmt --fail --list policies tests/policies
opa test policies tests/policies -v
~~~

The current test suite passes:

~~~text
PASS: 12/12
~~~

---

## CI/CD Security Gate

GitHub Actions automatically validates security policy and Terraform configuration.

The pipeline performs:

~~~text
Git Push / Pull Request
        ↓
┌──────────────────────────────┐
│ OPA Policy Tests             │
└──────────────────────────────┘
        +
┌──────────────────────────────┐
│ Terraform Format + Validate  │
└──────────────────────────────┘
        ↓
Federated GitHub → GCP Identity
        ↓
Terraform Plan
        ↓
SENTINEL CI Gate
~~~

The workflow uses Workload Identity Federation instead of storing Google Cloud credentials as GitHub secrets.

Workflow:

`.github/workflows/sentinel-policy-gate.yml`

---

## Automated Evidence Generation

SENTINEL includes an automated evidence generator:

`tools/evidence-generator/generate.py`

The generator:

1. Discovers security evidence artifacts
2. Calculates SHA-256 hashes
3. Records the current Git commit
4. Loads compliance mappings
5. Validates mapped evidence files
6. Produces a machine-readable manifest
7. Produces a human-readable security evidence report

Generated artifacts:

~~~text
evidence/generated/manifest.json
evidence/generated/security-evidence-report.md
~~~

The current implementation inventories more than twenty security evidence artifacts and maps them to multiple security frameworks.

---

## Compliance Traceability

SENTINEL demonstrates security-engineering traceability to:

- CIS-aligned security categories
- CMMC
- NIST SP 800-171
- NIST SP 800-53

Examples include mappings for:

### NIST SP 800-53

- AC-6 — Least Privilege
- AU-2 — Event Logging
- AU-12 — Audit Record Generation
- CM-2 — Baseline Configuration
- CM-3 — Configuration Change Control
- IA-5 — Authenticator Management
- SC-7 — Boundary Protection

### NIST SP 800-171

Examples include:

- 3.1.5 — Employ least privilege
- 3.3.1 — Create and retain system audit logs
- 3.4.1 — Establish and maintain baseline configurations
- 3.5.3 — Use protected authentication mechanisms
- 3.13.1 — Monitor and protect communications at boundaries

> These mappings demonstrate security engineering traceability. They do not represent a formal certification or compliance assessment.

---

## Repository Structure

~~~text
sentinel-multicloud-security/
├── .github/
│   └── workflows/
│       └── sentinel-policy-gate.yml
│
├── docs/
│   ├── architecture/
│   └── checkpoints/
│
├── environments/
│   ├── aws/
│   │   ├── dev/
│   │   └── prod/
│   └── gcp/
│       ├── dev/
│       └── prod/
│
├── evidence/
│   ├── examples/
│   ├── gcp/
│   └── generated/
│
├── k8s/
│   └── gcp/
│       ├── demo/
│       ├── network-policy/
│       └── workload-identity/
│
├── modules/
│   ├── aws/
│   │   ├── github-oidc/
│   │   └── secure-network/
│   └── gcp/
│       ├── github-wif/
│       ├── gke/
│       ├── iam-baseline/
│       ├── logging-baseline/
│       ├── secure-network/
│       └── security-baseline/
│
├── policies/
│   ├── compliance/
│   └── terraform/
│
├── tests/
│   ├── policies/
│   └── terraform/
│
└── tools/
    └── evidence-generator/
~~~

---

## Validation

### OPA

~~~bash
opa test policies tests/policies -v
~~~

Expected result:

~~~text
PASS: 12/12
~~~

### Terraform

~~~bash
cd environments/gcp/dev

terraform init
terraform validate
terraform plan
~~~

A fully synchronized environment should produce:

~~~text
No changes. Your infrastructure matches the configuration.
~~~

### Kubernetes

~~~bash
kubectl get nodes
kubectl get pods -o wide
kubectl get services
kubectl get networkpolicy
~~~

---

## Current Implementation Status

| Capability | GCP | AWS |
|---|---:|---:|
| Terraform foundation | ✅ | ✅ |
| Secure network module | ✅ | Scaffolded |
| GitHub federated identity | ✅ | OIDC foundation |
| IAM baseline | ✅ | Planned expansion |
| Logging baseline | ✅ | Planned expansion |
| Security baseline | ✅ | Planned expansion |
| Kubernetes platform | ✅ GKE | Planned EKS |
| Workload identity | ✅ | Planned IRSA |
| Network policy | ✅ | Planned |
| Binary authorization / admission controls | ✅ | Planned |
| OPA Terraform policy | ✅ | ✅ policy coverage |
| GitHub Actions security gate | ✅ | Shared |
| Automated evidence | ✅ | Extensible |
| Compliance traceability | ✅ | Extensible |

The current working implementation is intentionally **GCP-first**. AWS patterns and policy coverage establish the foundation for future parity without claiming infrastructure that has not yet been deployed.

---

## Key Security Engineering Concepts Demonstrated

SENTINEL demonstrates the ability to connect:

~~~text
Infrastructure as Code
        +
Identity Engineering
        +
Cloud Security
        +
Kubernetes Security
        +
Policy as Code
        +
CI/CD Security
        +
Audit Logging
        +
Evidence Automation
        +
Compliance Traceability
~~~

into a single repeatable cloud security engineering workflow.

---

## Interview Summary

A concise way to describe SENTINEL:

> I built SENTINEL as a secure cloud landing-zone and policy platform. I used Terraform to provision a custom GCP network, least-privilege IAM, logging and security baselines, and a regional GKE platform. I replaced static credentials with workload identity for both GitHub Actions and Kubernetes workloads, added OPA/Rego policy checks for IAM, storage, and metadata controls, and integrated those checks into GitHub Actions. I also automated security evidence generation and mapped the evidence to NIST, CMMC, and CIS-aligned security categories so the project demonstrates not only deployment, but security governance and traceability.

---

## Project Status

Core GCP SENTINEL engineering capabilities are operational:

- Infrastructure deployed
- GKE operational
- Identity hardened
- Policy tests passing
- CI security gate passing
- Federated Terraform planning operational
- Evidence generation operational
- Compliance traceability operational

Final project work focuses on documentation, cost-conscious teardown, and portfolio presentation.
