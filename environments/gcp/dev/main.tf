module "github_wif" {
  source = "../../../modules/gcp/github-wif"

  project_id        = var.gcp_project_id
  github_owner      = "cblackii"
  github_repository = "sentinel-multicloud-security"
  github_branch     = "main"
}

module "secure_network" {
  source = "../../../modules/gcp/secure-network"

  project_id = var.gcp_project_id
  name       = "sentinel-dev"

  region              = local.gcp_region
  private_subnet_cidr = "10.20.0.0/20"
  pods_cidr           = "10.24.0.0/20"
  services_cidr       = "10.28.0.0/24"
}

module "iam_baseline" {
  source = "../../../modules/gcp/iam-baseline"

  project_id                   = var.gcp_project_id
  github_service_account_email = module.github_wif.service_account_email
  terraform_state_bucket_name  = "sentinel-tfstate-988087918854"
}

module "logging_baseline" {
  source = "../../../modules/gcp/logging-baseline"

  project_id = var.gcp_project_id

  data_access_services = [
    "storage.googleapis.com",
    "iam.googleapis.com",
    "secretmanager.googleapis.com",
    "container.googleapis.com",
  ]
}

module "security_baseline" {
  source = "../../../modules/gcp/security-baseline"

  project_id = var.gcp_project_id

  security_services = [
    "secretmanager.googleapis.com",
    "cloudkms.googleapis.com",
    "containeranalysis.googleapis.com",
    "binaryauthorization.googleapis.com",
  ]
}

module "gke" {
  source = "../../../modules/gcp/gke"

  project_id = var.gcp_project_id
  name       = "sentinel-dev-gke"
  region     = local.gcp_region

  network    = module.secure_network.network_name
  subnetwork = module.secure_network.subnet_name

  pods_secondary_range_name     = module.secure_network.pods_secondary_range_name
  services_secondary_range_name = module.secure_network.services_secondary_range_name

  node_machine_type          = "e2-standard-2"
  node_count                 = 1
  node_service_account_email = module.iam_baseline.gke_node_service_account_email
}
