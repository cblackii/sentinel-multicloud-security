resource "google_project_service" "security_services" {
  for_each = var.security_services

  project = var.project_id
  service = each.value

  disable_on_destroy = false
}
