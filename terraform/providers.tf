terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "vault" {
  address = "http://10.0.1.9:8200"
  token   = var.vault_token
}

terraform {
  backend "gcs" {
    bucket  = "tf-state-testing-project"
    prefix  = "state"
  }
}