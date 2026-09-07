locals {
  github_repository = "${var.github_owner}/${var.github_repository}"
  github_ref        = "refs/heads/${var.github_branch}"
}

resource "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = var.pool_id
  display_name              = "SENTINEL GitHub Actions"
  description               = "Federated identities for SENTINEL GitHub Actions workflows."
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  display_name                       = "GitHub"
  description                        = "GitHub OIDC provider for SENTINEL."

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.ref"              = "assertion.ref"
  }

  attribute_condition = <<-EOT
    assertion.repository == "${local.github_repository}" &&
    assertion.ref == "${local.github_ref}"
  EOT

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "github" {
  project      = var.project_id
  account_id   = var.service_account_id
  display_name = "SENTINEL GitHub Deployment"
  description  = "Service account impersonated by approved SENTINEL GitHub Actions workflows."
}

resource "google_service_account_iam_member" "github_workload_identity" {
  service_account_id = google_service_account.github.name
  role               = "roles/iam.workloadIdentityUser"

  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${local.github_repository}"
}
