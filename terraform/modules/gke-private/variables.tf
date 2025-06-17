variable "name" {
  description = "name of GKE cluster"
  type = string
}

variable "network" {
    description = "network vpc for gke cluster"
}

variable "subnetwork" {
    description = "subnetwork for gke cluster"
}

variable "region" {
  description = "region of GKE cluster"
  type = string
}

variable "remove_default_node_pool" {
    description = "remove default node pool"
    type = bool
}

variable "node_pools" {
  description = "List of node pools"
  type = list(object({
    node_pool_name          = string
    region_node_pool       = string
    node_count = number
    enable_private_nodes = bool
    preemptible = bool
    machine_type = string
    disk_size_gb = number
    disk_type = string
  }))
}