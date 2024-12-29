resource "aws_lb_target_group" "catalogue" {
  name     = "${local.name}-${var.tags.Componenet}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value

  health_check {
    healthy_threshold = 2
    interval = 10
    unhealthy_threshold = 3
    timeout = 5
    path = "/health"
    port = 8080
    matcher = "200-299"
  }
  # tags = merge(
  #   var.common_tags,
  #   var.tags
  # )
}
module "catalogue" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name = "${local.name}-${var.tags.Componenet}-ami"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  subnet_id              = element(split(",",data.aws_ssm_parameter.priavte_subnets_ids.value),0)
  # the following will attach a ec2 file
  iam_instance_profile = "ec2-role-shell-script"
  tags = merge(
    var.common_tags,
    var.tags
  )
}
resource "null_resource" "catalogue" {
  triggers = {
    instance_id = module.catalogue.id
  }

  connection {
    host = module.catalogue.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo /tmp/bootstrap.sh catalogue dev" # you need to provide the arguments for shell script to get it executed by remote-exec
    ]
  }
}