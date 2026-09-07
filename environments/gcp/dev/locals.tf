locals {
  project     = "sentinel"
  environment = "dev"
  gcp_region  = "us-west1"

  common_labels = {
    project     = local.project
    environment = local.environment
    managed_by  = "terraform"
    repository  = "sentinel-multicloud-security"
  }
}
