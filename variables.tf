variable "region" {
  description = "The region where resources will be created"
  type        = string
  default     = "us-east1"

}
variable "subnet-cidr-1" {
  description = "The CIDR range for subnet 1"
  type        = string
  default     = "192.168.1.0/24"
}

variable "subnet_cidr-2" {
  description = "The CIDR range for subnet 2"
  type        = string
  default     = "192.168.2.0/24"
}

variable "subnet-cidr-3" {
  description = "The CIDR range for subnet 3"
  type        = string
  default     = "192.168.3.0/24"
}

variable "subnet-cidr-4" {
  description = "The CIDR range for subnet 4"
  type        = string
  default     = "192.168.4.0/24"
}

variable "subnet-cidr-5" {
  description = "The CIDR range for subnet 5"
  type        = string
  default     = "192.168.5.0/24"
}

variable "router-name" {
  description = "The name of the Cloud Router"
  type        = string
  default     = "my-cloud-router"
}

variable "zone" {
  description = "Compute zone"
  type        = string
  default     = "us-east1-b"
}

variable "app_machine_type" {
  description = "Machine type for app server"
  type        = string
  default     = "e2-medium"
}

variable "app_disk_size" {
  description = "Boot disk size (GB)"
  type        = number
  default     = 10
}

variable "app_image" {
  description = "OS image for app server"
  type        = string
  default     = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2510-questing-amd64-v20251210"
}

variable "compute_service_account" {
  description = "Service account for compute instances"
  type        = string
  default     = "1063108248548-compute@developer.gserviceaccount.com"
}
