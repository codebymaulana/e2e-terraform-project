output "instances" {
  value = var.instances
}

output "internal_ips" {
  value = {
    for k, inst in google_compute_instance.compute_engine :
    k => inst.network_interface[0].network_ip
  }
}

output "public_ips" {
  value = {
    for k, inst in google_compute_instance.compute_engine :
    k => inst.network_interface[0].access_config[0].nat_ip
  }
}