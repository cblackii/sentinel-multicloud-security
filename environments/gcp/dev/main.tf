module "github_wif" {
  source = "../../../modules/gcp/github-wif"

  project_id        = var.gcp_project_id
  github_owner      = "cblackii"
  github_repository = "sentinel-multicloud-security"
  github_branch     = "main"
}
