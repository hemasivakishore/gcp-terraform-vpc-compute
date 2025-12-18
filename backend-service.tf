# backend-service.tf

resource "google_compute_instance_group" "web_server_group" {
  name    = "web-server-group"
  zone    = var.zone
  network = google_compute_network.vpc-main.id

  instances = [google_compute_instance.web_server.self_link]
  named_port {
    name = "http"
    port = 80
  }

  depends_on = [google_compute_instance.web_server]
}

# Health Check to monitor Nginx on port 80

resource "google_compute_health_check" "http_health_check" {
  name               = "lb-http-health-check"
  check_interval_sec = 5
  timeout_sec        = 5

  http_health_check {
    port = 80
  }
}

# Backend Service to link Instance Group and Health Check
resource "google_compute_backend_service" "web_backend" {
  name                  = "web-backend-service"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks         = [google_compute_health_check.http_health_check.self_link]

  backend {
    group = google_compute_instance_group.web_server_group.self_link
  }
}

# URL Map for HTTPS Traffic Routing
resource "google_compute_url_map" "https_url_map" {
  name            = "web-https-url-map"
  default_service = google_compute_backend_service.web_backend.id
}

# URL Map for HTTP to HTTPS redirection
resource "google_compute_url_map" "http_redirection" {
  name = "http-to-https-redirect"
  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}
