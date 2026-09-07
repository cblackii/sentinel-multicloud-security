variable "project_id" {
  description = "GCP project ID where Workload Identity Federation resources are created."
  type        = string
}

variable "github_owner" {
  description = "GitHub organization or user that owns the trusted repository."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository trusted to use Workload Identity Federation."
  type        = string
}

variable "github_branch" {
  description = "Git branch trusted to federate into GCP."
  type        = string
  default     = "main"
}

variable "pool_id" {
  description = "Workload Identity Pool ID."
  type        = string
  default     = "sentinel-github"
}

variable "provider_id" {
  description = "Workload Identity Provider ID."
  type        = string
  default     = "github"
}

variable "service_account_id" {
  description = "Service account ID used by GitHub Actions."
  type        = string
  default     = "sentinel-github-deploy"
}
