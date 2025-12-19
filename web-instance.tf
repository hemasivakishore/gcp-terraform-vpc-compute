#web-instance.tf
# Static IP Reservation and App Server Instance Creation
resource "google_compute_address" "static_ip_web_server" {
  name   = "web-server-static-ip"
  region = google_compute_subnetwork.main-subnet-3.region # Ensure this matches your instance's region
}

# App Server Instance
resource "google_compute_instance" "web_server" {
  name         = "web-server"
  machine_type = var.app_machine_type
  zone         = var.zone

  tags = ["subnet-3", "web-server"]

  labels = {
    environment = "dev"
    role        = "web"
    managed_by  = "terraform"
  }

  boot_disk {
    auto_delete = true

    initialize_params {
      image = var.app_image
      size  = var.app_disk_size
      type  = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.main-subnet-3.id
    stack_type = "IPV4_ONLY"
    network_ip = var.web_server_internal_ip # Static internal IP
    # access_config {
    #   nat_ip = google_compute_address.static_ip_web_server.address # Assigns the reserved static IP
    # }
  }


  metadata = {
    startup-script = file("web-userdata.sh")
  }

  service_account {
    email = "1063108248548-compute@developer.gserviceaccount.com"
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    provisioning_model  = "STANDARD"
    preemptible         = false
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  can_ip_forward      = false
  deletion_protection = false
}
