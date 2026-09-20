variable "project_id" {
  description = "GCP project ID where the secure network will be created."
  type        = string
}

variable "name" {
  description = "Name of the GCP VPC network."
  type        = string
}

variable "region" {
  description = "GCP region for regional networking resources."
  type        = string
}

variable "private_subnet_cidr" {
  description = "Primary CIDR block for the private GCP subnet."
  type        = string
}

variable "pods_cidr" {
  description = "Secondary CIDR range reserved for GKE pods."
  type        = string
}

variable "services_cidr" {
  description = "Secondary CIDR range reserved for GKE services."
  type        = string
}

variable "enable_private_google_access" {
  description = "Enable Private Google Access for the subnet."
  type        = bool
  default     = true
}
