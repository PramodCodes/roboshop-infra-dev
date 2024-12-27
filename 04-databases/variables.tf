variable "common_tags" {
    default = {
        Project = "roboshop"
        Environment = "dev"
        Terraform = true
    }
}

variable "sg_tags" {
    default = {}
}

variable "project_name" {
    default = "roboshop"
    type = string
}

variable "environment" {
    default = "dev"
    type = string
}

variable "zone_name" {
    default = "pka.in.net"
    type = string
}