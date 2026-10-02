variable "project_id" {
  description = "GCP project ID."
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
