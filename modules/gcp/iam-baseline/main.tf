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
