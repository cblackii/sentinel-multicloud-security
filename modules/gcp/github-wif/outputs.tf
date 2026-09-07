output "workload_identity_pool_id" {
  description = "Workload Identity Pool resource name."
  value       = google_iam_workload_identity_pool.github.name
}

output "workload_identity_provider_name" {
  description = "Workload Identity Provider resource name."
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "service_account_email" {
  description = "Service account email used by GitHub Actions."
  value       = google_service_account.github.email
}
