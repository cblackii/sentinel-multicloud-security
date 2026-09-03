# SENTINEL Architecture Overview

## Purpose

SENTINEL is a multi-cloud secure landing zone and policy platform designed to demonstrate how a centralized cloud security engineering team can provide secure-by-default infrastructure across AWS and Google Cloud without becoming a delivery bottleneck.

The central engineering question is:

> How can the secure path become the easiest path for teams building in the cloud?

SENTINEL addresses this through reusable Terraform modules, federated identity, preventive policy-as-code, provider-native security controls, automated validation, and compliance evidence generation.

## Architecture Principles

1. Secure by default
2. Identity over static credentials
3. Prevent before detecting
4. Cloud-native where provider context matters
5. Portable where standardization adds value
6. Every security claim should be testable
7. Evidence should be produced by engineering

## High-Level Architecture

```text
Engineering Team
       |
       v
GitHub Actions
       |
       +-- Terraform Validation
       +-- Security Scanning
       +-- OPA/Rego Policy Checks
       |
       v
   Allow / Deny
       |
       v
Reusable Terraform Security Modules
       |
   +---+---+
   |       |
   v       v
  AWS     GCP
   |       |
Native Security and Audit Controls
   |       |
   +---+---+
       |
       v
Evidence Generator
    Python
       |
       v
Protected Evidence Repository
