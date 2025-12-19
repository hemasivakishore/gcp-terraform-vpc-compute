# # firewall.tf
# # Allows web ↔ app ↔ db communication inside VPC
# # Accept traffic only from LB subnet
# resource "google_compute_firewall" "allow_subnet1_to_subnet2_http_https" {
#   name    = "fw-subnet1-to-subnet2-http-https"
#   network = google_compute_network.vpc-main.name

#   direction = "INGRESS"
#   priority  = 1000

#   allow {
#     protocol = "tcp"
#     ports    = ["80", "443"]
#   }

#   source_ranges = [
#     #"192.168.1.0/24",
#     "35.191.0.0/16",
#     "130.211.0.0/22"
#   ]

#   target_tags = ["subnet-2"]
# }

# # Allow ONLY traffic from subnet-2 (App → App/Service)
# resource "google_compute_firewall" "allow_subnet2_to_subnet3" {
#   name    = "fw-subnet2-to-subnet3-app"
#   network = google_compute_network.vpc-main.name

#   direction = "INGRESS"
#   priority  = 1000

#   allow {
#     protocol = "tcp"
#     ports    = ["8080"]
#   }

#   source_ranges = [
#     "192.168.2.0/24"
#   ]

#   target_tags = ["subnet-3"]
# }

# # Allow ONLY traffic from subnet-3 (App → DB)
# resource "google_compute_firewall" "allow_subnet3_to_subnet4_db" {
#   name    = "fw-subnet3-to-subnet4-db"
#   network = google_compute_network.vpc-main.name

#   direction = "INGRESS"
#   priority  = 1000

#   allow {
#     protocol = "tcp"
#     ports    = ["3306", "5432"]
#   }

#   source_ranges = [
#     "192.168.3.0/24"
#   ]

#   target_tags = ["subnet-4"]
# }

# # Firewall rules do NOT decide NAT location. NAT works at VPC + Cloud Router level, not subnet level. So we allow egress, and NAT handles internet routing.
# resource "google_compute_firewall" "allow_all_egress" {
#   name    = "fw-allow-egress-via-nat"
#   network = google_compute_network.vpc-main.name

#   direction = "EGRESS"
#   priority  = 1000

#   allow {
#     protocol = "all"
#   }

#   destination_ranges = ["0.0.0.0/0"]
# }

# # Internal ICMP (Debugging)
# resource "google_compute_firewall" "allow_icmp_internal" {
#   name    = "fw-allow-icmp-internal"
#   network = google_compute_network.vpc-main.name

#   direction = "INGRESS"

#   allow {
#     protocol = "icmp"
#   }

#   source_ranges = [
#     "192.168.0.0/16"
#   ]
# }

# 1. LB -> Web Server (Port 80/443)
resource "google_compute_firewall" "allow_lb_to_web" {
  name    = "fw-allow-lb-to-web"
  network = google_compute_network.vpc-main.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  # Mandatory for GCLB Health Checks and Traffic
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["web-server"]
}

# 2. Web Server -> App Server (Port 8080)
resource "google_compute_firewall" "allow_web_to_app" {
  name    = "fw-allow-web-to-app"
  network = google_compute_network.vpc-main.name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  # Source: The subnet where your web-server lives
  source_ranges = [var.subnet-cidr-3] # 192.168.3.0/24
  target_tags   = ["app-server"]
}

# 3. App Server -> DB Server (MySQL/Postgres)
resource "google_compute_firewall" "allow_app_to_db" {
  name    = "fw-allow-app-to-db"
  network = google_compute_network.vpc-main.name

  allow {
    protocol = "tcp"
    ports    = ["3306", "5432"]
  }

  # Source: The subnet where your app-server lives
  source_ranges = [var.subnet-cidr-4] # 192.168.4.0/24
  target_tags   = ["db-server"]
}


# Allow all egress traffic from instances to enable NAT routing
resource "google_compute_firewall" "allow_all_egress" {
  name      = "fw-allow-all-egress"
  network   = google_compute_network.vpc-main.name
  direction = "EGRESS"
  priority  = 1000
  allow {
    protocol = "all"
  }
  destination_ranges = ["0.0.0.0/0"]
}

# Allow SSH for debugging (optional)
# remove if you don't need SSH access
resource "google_compute_firewall" "allow_ssh" {
  name      = "fw-allow-ssh"
  network   = google_compute_network.vpc-main.name
  direction = "INGRESS"
  priority  = 1000
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server", "app-server", "db-server"]
}

# Ensure all instances can talk to the internet for packages and updates via NAT
resource "google_compute_firewall" "allow_egress_for_updates" {
  name    = "fw-allow-egress-for-updates"
  network = google_compute_network.vpc-main.name

  direction = "EGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  destination_ranges = ["0.0.0.0/0"]
}
