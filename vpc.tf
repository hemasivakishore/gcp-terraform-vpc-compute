resource "google_compute_network" "vpc-main" {
  name                    = "vpc-main"
  auto_create_subnetworks = false
}
