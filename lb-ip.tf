# lb-ip.tf
# Reserve a Global Static External IP
resource "google_compute_global_address" "lb_ip" {
  name = "web-mgmt-lb-ip"
}

