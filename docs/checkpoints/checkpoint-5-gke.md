# Checkpoint 5 — Secure GKE Workload Platform

## Objective

Extend SENTINEL from secure cloud foundations into a running Kubernetes workload environment in Google Cloud.

The objective was not simply to deploy GKE. The build demonstrates:

- Infrastructure as Code with Terraform
- custom VPC-native GKE networking
- dedicated pod and service address ranges
- GKE Dataplane V2
- Kubernetes workload deployment
- keyless Google Cloud authentication through Workload Identity Federation
- least-privilege IAM authorization
- pod-to-pod traffic restriction with Kubernetes NetworkPolicy
- positive and negative security validation

---

## Architecture

```text
                         GitHub / Terraform
                                |
                                v
                        Google Cloud Platform
                                |
                         sentinel-dev VPC
                                |
                     sentinel-dev-private subnet
                          /               \
                         /                 \
                Pod secondary range   Service range
                  10.24.0.0/20          10.28.0.0/24
                         |
                         v
                  sentinel-dev-gke
                         |
                  GKE Dataplane V2
                         |
            +------------+-------------+
            |                          |
            v                          v
       hello-gke                  sentinel-wif-test
       nginx pod                       |
            |                           |
       ClusterIP Service       Kubernetes ServiceAccount
            |                    sentinel-demo
            |                           |
            |                           v
            |                 Workload Identity Federation
            |                           |
            |                           v
            |                      Google IAM
            |                           |
            |                           v
            |                     GCS test bucket
            |
            v
      NetworkPolicy
      approved traffic only
<EOF>
