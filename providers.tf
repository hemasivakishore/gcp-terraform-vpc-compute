# providers.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.14.0"
    }
  }
}

provider "google" {
  project     = "project-1e2da3fc-bb97-4b70-9c0"
  region      = "us-east1"
  zone        = "us-east1-b"
  credentials = file("~/.gcp/sa.json")
}
