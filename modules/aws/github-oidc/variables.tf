variable "github_owner" {
  description = "GitHub organization or user that owns the trusted repository."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name trusted to assume the AWS role."
  type        = string
}

variable "github_branch" {
  description = "Git branch trusted to assume the AWS role."
  type        = string
  default     = "main"
}

variable "role_name" {
  description = "Name of the IAM role used by GitHub Actions."
  type        = string
  default     = "sentinel-github-deploy"
}

variable "tags" {
  description = "Tags applied to supported AWS resources."
  type        = map(string)
  default     = {}
}
