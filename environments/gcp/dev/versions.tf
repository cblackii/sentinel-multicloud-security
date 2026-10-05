terraform {
  required_version = ">= 1.8, < 2.0"

  backend "gcs" {
    bucket = "sentinel-tfstate-988087918854"
    prefix = "environments/gcp/dev"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0, < 8.0"
    }
  }
}
