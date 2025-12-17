resource "google_compute_subnetwork" "main-subnet-1" {
  name          = "main-subnet-1"
  ip_cidr_range = var.subnet-cidr-1
  region        = var.region
  network       = google_compute_network.vpc-main.name
}

resource "google_compute_subnetwork" "main-subnet-2" {
  name          = "main-subnet-2"
  ip_cidr_range = var.subnet_cidr-2
  region        = var.region
  network       = google_compute_network.vpc-main.name
}

resource "google_compute_subnetwork" "main-subnet-3" {
  name          = "main-subnet-3"
  ip_cidr_range = var.subnet-cidr-3
  region        = var.region
  network       = google_compute_network.vpc-main.name
}

resource "google_compute_subnetwork" "main-subnet-4" {
  name          = "main-subnet-4"
  ip_cidr_range = var.subnet-cidr-4
  region        = var.region
  network       = google_compute_network.vpc-main.name
}

resource "google_compute_subnetwork" "main-subnet-5" {
  name          = "main-subnet-5"
  ip_cidr_range = var.subnet-cidr-5
  region        = var.region
  network       = google_compute_network.vpc-main.name
}
