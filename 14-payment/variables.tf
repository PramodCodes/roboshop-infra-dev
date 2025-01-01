
variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "iam_instance_profile" {
  default = "ec2-role-shell-script"
}

variable "common_tags" {
  default = {
    Project     = "roboshop"
    Environment = "dev"
    Terraform   = "true"
  }
}

variable "tags" {
  default = {
    Componenet = "payment"
  }
}

variable "zone_name" {
  default = "pka.in.net"
}
