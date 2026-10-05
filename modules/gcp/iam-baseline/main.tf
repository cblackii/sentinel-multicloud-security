resource "google_service_account" "gke_node" {
  project      = var.project_id
  account_id   = var.gke_node_service_account_id
  display_name = var.gke_node_service_account_display_name
  description  = "Dedicated least-privilege service account for SENTINEL GKE worker nodes."
}

resource "google_project_iam_member" "gke_default_node_service_account" {
  project = var.project_id
  role    = "roles/container.defaultNodeServiceAccount"
  member  = "serviceAccount:${google_service_account.gke_node.email}"
}

# GitHub Actions authenticates as this service account through Workload Identity
# Federation. These read-only roles let Terraform inspect resources, IAM policy,
# and enabled APIs while preventing CI from creating, changing, or deleting them.
resource "google_project_iam_member" "github_terraform_viewer" {
  project = var.project_id
  role    = "roles/viewer"
  member  = "serviceAccount:${var.github_service_account_email}"
}

resource "google_project_iam_member" "github_terraform_security_reviewer" {
  project = var.project_id
  role    = "roles/iam.securityReviewer"
  member  = "serviceAccount:${var.github_service_account_email}"
}

resource "google_project_iam_member" "github_service_usage_viewer" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageViewer"
  member  = "serviceAccount:${var.github_service_account_email}"
}

# A plan needs to read the shared state, but it does not need to modify it.
# The workflow disables backend locking so this bucket grant remains read-only.
resource "google_storage_bucket_iam_member" "github_terraform_state_viewer" {
  bucket = var.terraform_state_bucket_name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.github_service_account_email}"
}
