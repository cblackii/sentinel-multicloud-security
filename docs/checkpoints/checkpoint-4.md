# Checkpoint 4 — Secure Multi-Cloud Networking

## Objective

Establish reusable secure networking patterns for AWS and Google Cloud that provide consistent segmentation, private connectivity, and controlled ingress/egress for future SENTINEL workloads.

## Design Principles

1. Private-by-default workload placement
2. Explicit network segmentation
3. Minimize direct internet exposure
4. Controlled ingress and egress paths
5. Provider-native networking controls
6. Reusable Terraform modules
7. Security controls should be testable
8. Cost-conscious sandbox design

## AWS Target Architecture

The AWS module will eventually provide:

- VPC
- multiple Availability Zones
- private subnets
- optional public subnets where required
- route tables
- controlled internet egress
- security groups
- VPC endpoints for selected AWS services
- flow logging where appropriate

The intent is to keep application workloads private and expose only deliberately approved entry points.

## GCP Target Architecture

The GCP module will eventually provide:

- custom-mode VPC
- regional subnet
- Private Google Access
- explicit firewall rules
- controlled ingress and egress
- flow logging where appropriate
- foundations for future VPC Service Controls integration

The intent is to prevent broad default connectivity and establish a reusable network security baseline.

## Cross-Cloud Security Goal

AWS and GCP use different networking primitives, but SENTINEL will enforce the same architectural intent:

- segment workloads
- reduce public exposure
- restrict network paths
- log security-relevant traffic
- make secure defaults reusable

## Current State

Checkpoint 4A establishes the module interfaces and design intent only.

No AWS or GCP networking resources have been deployed yet.

## Next Step

Implement the AWS secure-network module first, validate it locally, and review the Terraform plan before deployment.
