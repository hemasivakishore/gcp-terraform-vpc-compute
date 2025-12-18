// app-server.tf
resource "google_compute_address" "static_ip_app_server" {
  name   = "app-server-static-ip"
  region = google_compute_subnetwork.main-subnet-4.region # Ensure this matches your instance's region
}

# App Server Instance
resource "google_compute_instance" "app_server" {
  name         = "app-server"
  machine_type = var.app_machine_type
  zone         = var.zone

  tags = ["subnet-4", "app-server"]

  labels = {
    environment = "dev"
    role        = "app"
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
    subnetwork = google_compute_subnetwork.main-subnet-4.id
    stack_type = "IPV4_ONLY"
    # access_config {
    #   nat_ip = google_compute_address.static_ip_app_server.address # Assigns the reserved static IP
    # }
  }


  metadata = {
    startup-script = <<-EOF
      #!/bin/bash
      set -e
      apt update -y
      apt install -y nginx net-tools jq unzip curl
    EOF
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
