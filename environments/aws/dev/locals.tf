locals {
  project     = "sentinel"
  environment = "dev"
  aws_region  = "us-west-2"

  common_tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "Terraform"
    Repository  = "sentinel-multicloud-security"
  }
}
