variable "region" {
  description = "The region where resources will be created"
  type        = string

}
variable "subnet-cidr-1" {
  description = "The CIDR range for subnet 1"
  type        = string
}

variable "subnet_cidr-2" {
  description = "The CIDR range for subnet 2"
  type        = string
}

variable "subnet-cidr-3" {
  description = "The CIDR range for subnet 3"
  type        = string
}

variable "subnet-cidr-4" {
  description = "The CIDR range for subnet 4"
  type        = string
}

variable "router-name" {
  description = "The name of the Cloud Router"
  type        = string
}
