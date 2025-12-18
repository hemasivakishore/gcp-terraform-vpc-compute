# forwarding.tf

# Forwarding Rule for HTTPS Traffic
resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {
  name                  = "https-forwarding-rule"
  ip_address            = google_compute_global_address.lb_ip.address
  target                = google_compute_target_https_proxy.https_proxy.self_link
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

# Forwarding Rule for HTTP Traffic
resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name                  = "http-forwarding-rule"
  ip_address            = google_compute_global_address.lb_ip.address
  target                = google_compute_target_http_proxy.http_proxy.self_link
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}
