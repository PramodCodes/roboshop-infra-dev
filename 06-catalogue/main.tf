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
  subnet_id              = element(split(",",data.aws_ssm_parameter.private_subnets_ids.value),0)
  # the following will attach a ec2 file
  iam_instance_profile = "ec2-role-shell-script"
  tags = merge(
    var.common_tags,
    var.tags
  )
}

resource "null_resource" "catalogue" {
  # depends_on = [null_resource.wait_for_instance]
  triggers = {
    instance_id = module.catalogue.id
  }

  connection {
    host = module.catalogue.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
    # timeout     = "5m" # timeout for connection you can reduce or increase 

  }
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh catalogue dev" # you need to provide the arguments for shell script to get it executed by remote-exec
    ]
  }
}

# we need to write dependence on the running of catalogue service 
# other wise the instance will stop at the end of the terraform apply which is not desired
resource "aws_ec2_instance_state" "catalogue_instance_state_stop" {
  instance_id = module.catalogue.id
  state       = "stopped"
  depends_on = [ null_resource.catalogue ]
}
# we will add timestamp to the ami name to make it unique and to understand when it was created
resource "aws_ami_from_instance" "catalogue" {
  name               = "${local.name}-${var.tags.Componenet}-${local.current_time}"
  source_instance_id = module.catalogue.id
  # not sure if the following is needed
  depends_on         = [ aws_ec2_instance_state.catalogue_instance_state_stop ]
}

# terminate instance after creating ami
resource "null_resource" "catalogue_terminate" {
  # we are changing the trigger from every change of ami, instead we must do it instance
  # ami id will keep changing when timestamp changes, what happening is this instance will be terminated when instance is being configured
  # now the trigger (deletion) happens when catalogue isntance id changes
  
  triggers = {
  #   ami_id = aws_ami_from_instance.catalogue.id
    instance_id = module.catalogue.id
  }
# we already have a connection to the instance so we don't need remote exec we can use local exec
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.catalogue.id}"
  }
  depends_on = [ aws_ami_from_instance.catalogue ]
}

# now that we have ami created and deleted the instance lets create the launch template
resource "aws_launch_template" "catalogue_template" {
  name = "${local.name}-${var.tags.Componenet}"
  image_id = aws_ami_from_instance.catalogue.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro" 
  update_default_version = true # this will update the default version of the launch template for each new version of the launch template creation
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.name}-${var.tags.Componenet}"
    }
  }
    depends_on         = [ null_resource.catalogue_terminate ]
}
# way of issue fixing
# if you are running remote exec , the machiene you run must have access to it, 
# in other words , if you are running on windows you need to have vpn connection if you are trying to exec remote exec on private instance
# if issue is between instances check with ping or telent
# if it fails check ports , security groups, vpn peering connection , and firewall blocking in instance
