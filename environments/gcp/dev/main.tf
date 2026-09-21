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

module "gke" {
  source = "../../../modules/gcp/gke"

  project_id = var.gcp_project_id
  name       = "sentinel-dev-gke"
  region     = local.gcp_region

  network    = module.secure_network.network_name
  subnetwork = module.secure_network.subnet_name

  pods_secondary_range_name     = module.secure_network.pods_secondary_range_name
  services_secondary_range_name = module.secure_network.services_secondary_range_name

  node_machine_type = "e2-standard-2"
  node_count        = 1
}
