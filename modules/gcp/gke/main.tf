resource "google_container_cluster" "this" {
  project  = var.project_id
  name     = var.name
  location = var.region

  network    = var.network
  subnetwork = var.subnetwork

  remove_default_node_pool = true
  initial_node_count       = 1

  datapath_provider = "ADVANCED_DATAPATH"

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  release_channel {
    channel = "REGULAR"
  }

  deletion_protection = false
}

resource "google_container_node_pool" "primary" {
  project  = var.project_id
  name     = "${var.name}-primary"
  location = var.region
  cluster  = google_container_cluster.this.name

  node_count = var.node_count

  node_config {
    machine_type = var.node_machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
