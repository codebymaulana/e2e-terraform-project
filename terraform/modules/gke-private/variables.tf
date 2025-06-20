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

variable "location" {
  description = "region of GKE cluster"
  type = string
}

variable "remove_default_node_pool" {
    description = "remove default node pool"
    type = bool
}

variable "deletion_protection" {
    description = "delete protection"
    type = bool
}

variable "cluster_ipv4_cidr_block" {
  description = "ipv4 cidr for gke container"
  type = string
}

variable "services_ipv4_cidr_block" {
  description = "ipv4 cidr for gke svc"
  type = string
}



variable "node_pools" {
  description = "List of node pools"
  type = list(object({
    node_pool_name          = string
    node_count = number
    location = string
    enable_private_nodes = bool
    preemptible = bool
    machine_type = string
    disk_size_gb = number
    disk_type = string
  }))
}