variable "robobshop_vpc_cidr" {
    default = "10.0.0.0/16"
    type = string
}

variable "common_tags" {
    default = {
        Project = "roboshop"
        Environment = "dev"
        Terraform = true
    }
}

variable "vpc_tags" {
    default = {}
}

variable "project_name" {
    default = "roboshop"
    type = string
}

variable "project_environment" {
    default = "dev"
    type = string
}

variable "public_subnet_cidr" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnet_cidr" {
  default = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}
variable "database_subnet_cidr" {
  default = [
    "10.0.21.0/24",
    "10.0.22.0/24"
  ]
}

variable "is_peering_required" {
  default = true
  type = bool
}

variable "environment" {
    default = "dev"
    type = string
}