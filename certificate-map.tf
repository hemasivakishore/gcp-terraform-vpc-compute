# certificate-map.tf

# Create a NEW resource in the GLOBAL location
resource "google_certificate_manager_certificate" "self_managed_cert" {
  name     = "thehsk-shop"
  location = "global" # This is the critical change

  self_managed {
    # You can reference your local files or paste the PEM strings here
    pem_certificate = file("cert.crt")
    pem_private_key = file("private.key")
  }
}

# Create a Certificate Map to hold your certificate entries
resource "google_certificate_manager_certificate_map" "certificate_map" {
  name        = "web-certificate-map"
  description = "Certificate map for web application"
}

# Create a certificate map entry for your existing certificate
resource "google_certificate_manager_certificate_map_entry" "cert-map-entry" {
  name         = "cert-map-entry"
  map          = google_certificate_manager_certificate_map.certificate_map.name
  certificates = [google_certificate_manager_certificate.self_managed_cert.id]
  hostname     = "*.thehsk.shop" # Replace with your domain
}

# Note: Ensure that the Load Balancer's Target HTTPS Proxy references this certificate map
resource "google_compute_target_https_proxy" "https_proxy" {
  name            = "https-proxy"
  url_map         = google_compute_url_map.https_url_map.id
  certificate_map = "//certificatemanager.googleapis.com/${google_certificate_manager_certificate_map.certificate_map.id}"
}

# Target HTTP Proxy for Redirection
resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "web-http-proxy"
  url_map = google_compute_url_map.http_redirection.id
}
