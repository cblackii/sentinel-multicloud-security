# SENTINEL Terraform Conventions

## Purpose

This document defines the initial Terraform structure and working conventions for SENTINEL.

The goal is to keep reusable security patterns separate from environment-specific deployments so the repository can model how a central cloud security engineering team provides approved infrastructure patterns to engineering teams.

## Repository Model

SENTINEL separates reusable infrastructure from deployed environments.

```text
modules/
  aws/
  gcp/

environments/
  aws/dev/
  gcp/dev/
