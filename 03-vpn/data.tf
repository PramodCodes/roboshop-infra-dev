#getting latest ami id automatically
data "aws_ami" "centos8" {
    owners = ["973714476881"]
    most_recent      = true

    filter {
        name   = "name"
        values = ["Centos-8-DevOps-Practice"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

data "aws_vpc" "default_vpc_info" {
  default = true
}

data "aws_subnet" "default_vpc_subnet" {
  vpc_id = data.aws_vpc.default_vpc_info.id
  availability_zone = "us-east-1a"
}

data "aws_ssm_parameter" "default_vpn_sg_id" {
  name = "/${var.project_name}/${var.environment}/vpn_sg_id"
}
# this block is invalid block , i wrote this by mistake and spent almost half day in debugging this
# terraform will show error that the vpn module is not avialable in terraform registry 
# but if you see you are not using something like that in terraform at all
# you will check provider multiple times , but provider is correct and vpn is listed as below as module which will throw error
# always check type
# data "vpn_sg_id" "default_vpn_sg_id" {
#   name = "${var.project_name}/${var.environment}/vpn_sg_id"
# }

# to get default vpc subnet id in us-east-1a we are retrieving the default vpc info then default vpc subnet id
# output "default_vpc_info" {
#   value = data.aws_subnet.default_vpc_subnet.id
# }

# output "vpc_info" {
#   value = data.aws_subnet.selected.id
# }