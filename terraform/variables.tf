variable "project_id" { type = string }
variable "region"     { type = string }
variable "zone"       { type = string }
variable "ssh_public_key" { type = string }
variable "vault_token" { type = string sensitive = true }