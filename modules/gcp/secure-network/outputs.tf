output "network_id" {
  description = "ID of the GCP VPC network."
  value       = google_compute_network.this.id
}

output "network_name" {
  description = "Name of the GCP VPC network."
  value       = google_compute_network.this.name
}

output "subnet_id" {
  description = "ID of the private GCP subnet."
  value       = google_compute_subnetwork.private.id
}

output "subnet_name" {
  description = "Name of the private GCP subnet."
  value       = google_compute_subnetwork.private.name
}

output "pods_secondary_range_name" {
  description = "Secondary range used by GKE pods."
  value       = google_compute_subnetwork.private.secondary_ip_range[0].range_name
}

output "services_secondary_range_name" {
  description = "Secondary range used by GKE services."
  value       = google_compute_subnetwork.private.secondary_ip_range[1].range_name
}
