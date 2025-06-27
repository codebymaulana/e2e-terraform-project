resource "google_compute_instance" "compute_engine" {
  for_each = { for inst in var.instances : inst.name => inst }
  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = each.value.zone

  boot_disk {
    initialize_params {
      image = each.value.image
      size = each.value.boot_disk_size
      type = each.value.boot_disk_type
    }
  }

  network_interface {
    subnetwork = each.value.subnetwork
    access_config {}
  }

  metadata = {
    ssh-keys = "devops:${each.value.ssh_public_key}"
  }
}