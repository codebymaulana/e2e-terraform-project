variable "firewall" {
  description = "List of firewall configurations"
  type = list(object({
    name          = string
    network       = string
    protocol      = string
    ports         = list(string)
    source_ranges = list(string)
  }))
}