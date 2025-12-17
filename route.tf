# route.tf

# us-east4
resource "google_compute_router" "main-router-east4" {
  name    = "${var.router-name}-${google_compute_subnetwork.main-subnet-2.region}"
  region  = google_compute_subnetwork.main-subnet-2.region
  network = google_compute_network.vpc-main.id
}

# IP Address for the router
resource "google_compute_address" "router-ip-east4" {
  count  = 2
  name   = "${var.router-name}-ip-${count.index}"
  region = google_compute_subnetwork.main-subnet-2.region
  lifecycle {
    create_before_destroy = true
  }
}
