output "enabled_security_services" {
  description = "Security-related APIs managed by the SENTINEL security baseline."
  value       = sort(tolist(var.security_services))
}
