########################################
#  NETWORKING – call module VPC
########################################
module "network" {
  source     = "./modules/vpc"
  subnetwork_name  = "private-subnet"
  subnetwork_cidr  = "10.0.1.0/24"
  region           = var.region
}


########################################
#  FIREWALL – call module FIREWALL
########################################
module "firewall" {
    source  = "./modules/firewall"
    firewall = [
        {
            name = "allow-ssh-from-public"
            network = module.network.network_self_link
            protocol = "tcp"
            ports   = ["22"]
            source_ranges = ["0.0.0.0/0"]
        }
    ]
}


########################################
#  COMPUTE – call module VM/Instance
########################################
module "compute" {
  source           = "./modules/compute"
  instances = [
    {
      name            = "db-postgresql"
      machine_type    = "e2-medium"
      zone            = var.zone
      image           = "ubuntu-minimal-2204-jammy-v20250611"
      boot_disk_size  = 20
      boot_disk_type  = "pd-standard"
      subnetwork      = module.network.subnetwork_self_link
      run_ansible     = false
      config_version  = "v1"
      ssh_public_key  = var.ssh_public_key
    }
  ]
}


########################################
#  GKE – call module GKE cluster
########################################
module "gke-private" {
  source           = "./modules/gke-private"
  name = "gke-cluster"
  network = module.network.network_self_link
  subnetwork = module.network.subnetwork_self_link
  remove_default_node_pool = true
  location = var.zone
  deletion_protection = false
  cluster_ipv4_cidr_block  = "10.4.0.0/14"
  services_ipv4_cidr_block = "10.0.32.0/20"
  node_pools = [
    {
       node_pool_name = "node-pool-1"
       node_count = 3
       enable_private_nodes = true
       location = var.zone
       machine_type = "e2-medium"
       preemptible = true
       disk_size_gb = 20
       disk_type = "pd-standard"
    }
  ]
}

resource "null_resource" "ansible_runner" {
  for_each = {
    for inst in module.compute.instances : inst.name => inst
    if inst.run_ansible
  }

  triggers = {
    instance_name = each.value.name
    ip_address    = module.compute.public_ips[each.key]
    config_tag    = each.value.config_version
  }

  provisioner "local-exec" {
    command = <<EOT
      sleep 60
      cd /home/fmaulana/Documents/belajar/e2e-terraform-project/ansible/
      ANSIBLE_VAULT_PASSWORD_FILE="vault_pass.txt" ansible-playbook -i '${self.triggers.ip_address},' playbook.yml --extra-vars "target_host=${self.triggers.ip_address}" -e "@vars.yaml"
    EOT
  }

  depends_on = [module.compute]
}
