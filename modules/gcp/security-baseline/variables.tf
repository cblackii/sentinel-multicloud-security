variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "security_services" {
  description = "Security-related Google Cloud APIs that should be enabled."
  type        = set(string)

  default = [
    "secretmanager.googleapis.com",
    "cloudkms.googleapis.com",
    "containeranalysis.googleapis.com",
    "binaryauthorization.googleapis.com",
  ]
}
