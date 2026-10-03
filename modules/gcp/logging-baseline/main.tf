resource "google_project_iam_audit_config" "data_access" {
  for_each = toset(var.data_access_services)

  project = var.project_id
  service = each.value

  audit_log_config {
    log_type = "DATA_READ"
  }

  audit_log_config {
    log_type = "DATA_WRITE"
  }
}
