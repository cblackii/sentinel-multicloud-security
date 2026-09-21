variable "project_id" {
  description = "GCP project ID where the GKE cluster will be created."
  type        = string
}

variable "name" {
  description = "Name of the GKE cluster."
  type        = string
}

variable "region" {
  description = "GCP region for the regional GKE cluster."
  type        = string
}

variable "network" {
  description = "VPC network name or self-link used by the cluster."
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name or self-link used by the cluster."
  type        = string
}

variable "pods_secondary_range_name" {
  description = "Secondary subnet range name used for GKE pods."
  type        = string
}

variable "services_secondary_range_name" {
  description = "Secondary subnet range name used for GKE services."
  type        = string
}

variable "node_machine_type" {
  description = "Machine type for the GKE node pool."
  type        = string
  default     = "e2-standard-2"
}

variable "node_count" {
  description = "Initial node count for the GKE node pool."
  type        = number
  default     = 1
}
