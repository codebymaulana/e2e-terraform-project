resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_container_cluster" "primary" {
  name     = var.name
  location = var.location
  network = var.network
  subnetwork = var.subnetwork
  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = 1
  deletion_protection = var.deletion_protection
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }


}

resource "google_container_node_pool" "node_pools" {
  for_each = { for node in var.node_pools : node.node_pool_name => node }
  name       = each.value.node_pool_name
  location   = each.value.location
  cluster    = google_container_cluster.primary.name
  node_count = each.value.node_count


  network_config {
    enable_private_nodes = each.value.enable_private_nodes
  }


  node_config {
    disk_size_gb = each.value.disk_size_gb
    disk_type       = each.value.disk_type
    preemptible  = each.value.preemptible
    machine_type = each.value.machine_type
    service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}