module "github_oidc" {
  source = "../../../modules/aws/github-oidc"

  github_owner      = "cblackii"
  github_repository = "sentinel-multicloud-security"
  github_branch     = "main"

  tags = local.common_tags
}
