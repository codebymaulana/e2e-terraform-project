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
  credentials = jsondecode(var.google_credentials)
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket  = "tf-state-testing-project"
    prefix  = "state"
  }
}