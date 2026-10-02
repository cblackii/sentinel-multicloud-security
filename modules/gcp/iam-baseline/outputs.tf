output "gke_node_service_account_email" {
  description = "Email address of the dedicated GKE node service account."
  value       = google_service_account.gke_node.email
}

output "gke_node_service_account_name" {
  description = "Fully qualified name of the dedicated GKE node service account."
  value       = google_service_account.gke_node.name
}
