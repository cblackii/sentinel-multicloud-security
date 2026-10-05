variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "github_service_account_email" {
  description = "Email address of the GitHub Actions service account used for read-only Terraform planning."
  type        = string
}

variable "terraform_state_bucket_name" {
  description = "GCS bucket containing shared Terraform state."
  type        = string
}

variable "gke_node_service_account_id" {
  description = "Account ID for the dedicated GKE node service account."
  type        = string
  default     = "sentinel-gke-node"
}

variable "gke_node_service_account_display_name" {
  description = "Display name for the dedicated GKE node service account."
  type        = string
  default     = "SENTINEL GKE Node Service Account"
}
