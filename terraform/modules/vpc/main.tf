resource "google_compute_subnetwork" "subnetwork" {
  name          = var.subnetwork_name
  ip_cidr_range = var.subnetwork_cidr
  region        = var.region
  network       = google_compute_network.custom-test.id
}

resource "google_compute_network" "custom-test" {
  name                    = "testing-network"
  auto_create_subnetworks = false
}

resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  network = google_compute_network.custom-test.id
  region  = "asia-southeast1"
}

resource "google_compute_address" "nat_ip_0" {
  name   = "nat-ip-0"
  region = "asia-southeast1"
}

resource "google_compute_address" "nat_ip_1" {
  name   = "nat-ip-1"
  region = "asia-southeast1"
}

resource "google_compute_router_nat" "nat_config" {
  name   = "nat-config"
  router = google_compute_router.nat_router.name
  region = "asia-southeast1"

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips = [google_compute_address.nat_ip_0.self_link,google_compute_address.nat_ip_1.self_link]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  enable_dynamic_port_allocation = true
  log_config {
    enable = false
    filter = "ERRORS_ONLY"
  }
}
