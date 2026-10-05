# Checkpoint 7 — Policy-as-Code with OPA/Rego

## Objective

Add preventive controls that evaluate Terraform plan JSON before infrastructure
is deployed. Terraform describes the proposed change; OPA evaluates that change
and returns actionable deny messages when it violates a SENTINEL guardrail.

## Initial policy pack

The first pack covers three high-value control families across AWS and GCP:

1. **Public storage** — requires GCS public access prevention, rejects public GCS
   principals, rejects public S3 ACLs and policies, and requires all four S3
   public-access-block settings when that resource is present.
2. **Overly broad IAM** — rejects GCP Owner/Editor grants, AWS Allow statements
   combining wildcard actions and resources, and selected broad AWS managed
   policies.
3. **Required metadata** — requires `project`, `environment`, and `managed_by`
   labels on selected GCP resources and their title-cased tag equivalents on
   selected AWS resources.

Delete-only changes and Terraform data sources are intentionally ignored. Policy
checks focus on managed resources being created or updated.

## Local validation

OPA is not required as a host-level install. The Makefile pins the official OPA
container image so local development and future CI use the same policy engine.

```bash
make policy-check
```

To evaluate a real Terraform plan:

```bash
terraform plan -out=tfplan
terraform show -json tfplan > tfplan.json
docker run --rm \
  -v "$PWD:/workspace" \
  --workdir /workspace \
  openpolicyagent/opa:1.21.1-static \
  eval --fail-defined \
  --data policies \
  --input tfplan.json \
  'data.sentinel.terraform.deny[_]'
```

Terraform plan files and JSON remain untracked because they can contain
sensitive or environment-specific values.

## CI enforcement next

The next change should add a GitHub Actions workflow that:

1. initializes Terraform without applying changes;
2. produces a saved plan and converts it to JSON;
3. runs `make policy-check` for policy regression tests;
4. evaluates all three deny sets against the plan JSON;
5. fails the pull request when any deny result exists; and
6. uploads a sanitized policy result as build evidence, never the raw plan.

CI should use the repository's existing keyless federation model and should not
introduce static cloud credentials.
