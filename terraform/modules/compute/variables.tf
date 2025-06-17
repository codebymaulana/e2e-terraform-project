variable "instances" {
  description = "List of Compute Instance configurations"
  type = list(object({
    name         = string
    image        = string
    zone         = string
    machine_type = string
    boot_disk_size = number
    boot_disk_type = string
    subnetwork     = string
    run_ansible    = optional(bool, false)
    config_version  = optional(string, "")
  }))
}