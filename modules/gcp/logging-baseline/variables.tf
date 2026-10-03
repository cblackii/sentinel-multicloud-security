variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "data_access_services" {
  description = "GCP services for which DATA_READ and DATA_WRITE audit logging should be enabled."
  type        = list(string)

  default = [
    "storage.googleapis.com",
    "iam.googleapis.com",
    "secretmanager.googleapis.com",
    "container.googleapis.com",
  ]
}
