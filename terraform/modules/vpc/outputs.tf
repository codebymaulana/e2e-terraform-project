output "subnetwork_self_link" {
  value = google_compute_subnetwork.subnetwork.self_link
}

output "network_self_link" {
  value = google_compute_network.custom-test.self_link
}
