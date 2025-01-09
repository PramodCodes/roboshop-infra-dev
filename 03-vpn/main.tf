module "vpn" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami                    = data.aws_ami.centos8.id
  name                   = "${local.ec2_name}-vpn"
  instance_type          = "t3.medium"
  vpc_security_group_ids = [data.aws_ssm_parameter.default_vpn_sg_id.value]
# if you dont clealy metion .value you wont get the value since its an object you will see error
# we need sg for vpn before the vpn instance
  subnet_id              = data.aws_subnet.default_vpc_subnet.id
# the following is the user_data script that will be executed on the instance to setup vpn
  user_data = templatefiles(
                ["openvpn.sh",
                  "agent_setup.sh"
                ]) # file is a function to load files
  tags = merge(
    var.common_tags,
    {
      Component = "vpn"
    },
    {
      Name = "${local.ec2_name}-vpn"
    }
  )
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = "pka.in.net"

  records = [
    {
      name    = "vpn"
      type    = "A"
      ttl     = 1
      records = [
        "${module.vpn.public_ip}",
      ]
    },    
    {
      name    = "jenkinsagnet"
      type    = "A"
      ttl     = 1
      records = [
        "${module.vpn.private_ip}",
      ]
    },
  ]
}
# resource "null_resource" "vpn" {

#   triggers = {
#     instance_id = module.vpn.id
#   }

#   connection {
#     host = module.vpn.public_ip
#     type = "ssh"
#     user = "centos"
#     password = "DevOps321"
#   }
#   provisioner "file" {
#     source      = "agent_setup.sh"
#     destination = "/tmp/agent_setup.sh"
#   }
#   provisioner "remote-exec" {
#     # Bootstrap script called with private_ip of each node in the cluster
#     inline = [
#       "chmod +x /tmp/agent_setup.sh",
#       "sudo /tmp/agent_setup.sh" # you need to provide the arguments for shell script
#     ]
#   }
# }