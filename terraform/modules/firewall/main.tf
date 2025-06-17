resource "google_compute_firewall" "default" {
  for_each = { for rules in var.firewall : rules.name => rules }
  name    = each.value.name
  network = each.value.network

  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }
  source_ranges = each.value.source_ranges
}