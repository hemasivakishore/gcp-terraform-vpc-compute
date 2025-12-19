// nat-gateway.tf
# Cloud NAT Gateway configuration
resource "google_compute_router_nat" "main-nat" {
  name                               = "${var.router-name}-nat"
  router                             = google_compute_router.main-router-east4.name
  region                             = google_compute_router.main-router-east4.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.router-ip-east4.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
