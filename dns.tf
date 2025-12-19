# dns.tf

# Fetch the existing managed zone
data "google_dns_managed_zone" "env_dns_zone" {
  name = "thehskshop"
}

# Create A record for www.thehsk.shop pointing to the Load Balancer IP
resource "google_dns_record_set" "www_record" {
  name         = "www.${data.google_dns_managed_zone.env_dns_zone.dns_name}"
  managed_zone = data.google_dns_managed_zone.env_dns_zone.name
  type         = "A"
  ttl          = 300

  # This uses the IP address defined in your lb_ip resource
  rrdatas = [google_compute_global_address.lb_ip.address]
}
