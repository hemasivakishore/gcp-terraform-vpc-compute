# firewall.tf
# Allows web ↔ app ↔ db communication inside VPC
# Accept traffic only from LB subnet
resource "google_compute_firewall" "allow_subnet1_to_subnet2_http_https" {
  name    = "fw-subnet1-to-subnet2-http-https"
  network = google_compute_network.vpc-main.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = [
    "192.168.1.0/24"
  ]

  target_tags = ["subnet-2"]
}

# Allow ONLY traffic from subnet-2 (App → App/Service)
resource "google_compute_firewall" "allow_subnet2_to_subnet3" {
  name    = "fw-subnet2-to-subnet3-app"
  network = google_compute_network.vpc-main.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = [
    "192.168.2.0/24"
  ]

  target_tags = ["subnet-3"]
}

# Allow ONLY traffic from subnet-3 (App → DB)
resource "google_compute_firewall" "allow_subnet3_to_subnet4_db" {
  name    = "fw-subnet3-to-subnet4-db"
  network = google_compute_network.vpc-main.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["3306", "5432"]
  }

  source_ranges = [
    "192.168.3.0/24"
  ]

  target_tags = ["subnet-4"]
}

# Firewall rules do NOT decide NAT location. NAT works at VPC + Cloud Router level, not subnet level. So we allow egress, and NAT handles internet routing.
resource "google_compute_firewall" "allow_all_egress" {
  name    = "fw-allow-egress-via-nat"
  network = google_compute_network.vpc-main.name

  direction = "EGRESS"
  priority  = 1000

  allow {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
}

# Internal ICMP (Debugging)
resource "google_compute_firewall" "allow_icmp_internal" {
  name    = "fw-allow-icmp-internal"
  network = google_compute_network.vpc-main.name

  direction = "INGRESS"

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "192.168.0.0/16"
  ]
}
