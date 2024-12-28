# instances creation for db tier using ansible pull
module "mongodb" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id

  name = "${local.ec2_name}-mongodb"

  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
# if you dont clealy metion .value you wont get the value since its an object you will see error
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    {
        Componenet = "mongodb"
    },{
        Name = "${local.ec2_name}-mongodb"
    })
}
# how we will know if userdata is success or failure ? we cannot so we will use terraform provisioners
# we can use null resource in terraform to connect with terraform provisioners , null resource means 
# it will not create any resource but it will run the provisioners and it is not related to any provisioners
resource "null_resource" "mongodb" {

  triggers = {
    instance_id = module.mongodb.id
  }

  connection {
    host = module.mongodb.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo /tmp/bootstrap.sh mongodb dev" # you need to provide the arguments for shell script
    ]
  }
}
# redis instance using ansible pull
module "redis" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name = "${local.ec2_name}-mongodb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
  subnet_id              = local.database_subnet_id
  tags = merge(
    var.common_tags,
    {
        Componenet = "redis"
    },{
        Name = "${local.ec2_name}-redis"
    })
}

resource "null_resource" "redis" {
  triggers = {
    instance_id = module.redis.id
  }
  connection {
    host = module.redis.private_ip
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
      "sudo /tmp/bootstrap.sh redis dev" # you need to provide the arguments for shell script
    ]
  }
}
# mysql instance using ansible pull
module "mysql" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name = "${local.ec2_name}-mongodb"
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  subnet_id              = local.database_subnet_id
  # the following will attach a ec2 file
  iam_instance_profile = "ec2-role-shell-script"
  tags = merge(
    var.common_tags,
    {
        Componenet = "mysql"
    },{
        Name = "${local.ec2_name}-mysql"
    })
}

resource "null_resource" "mysql" {
  triggers = {
    instance_id = module.mysql.id
  }

  connection {
    host = module.mysql.private_ip
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
      "sudo /tmp/bootstrap.sh mysql dev" # you need to provide the arguments for shell script
    ]
  }
}
# rabbitmq instance using ansible pull
# we will use ansible community module for rabbitmq
module "rabbitmq" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name = "${local.ec2_name}-rabbitmq"
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
  subnet_id              = local.database_subnet_id
  # the following will attach a ec2 file
  iam_instance_profile = "ec2-role-shell-script"
  tags = merge(
    var.common_tags,
    {
        Componenet = "rabbitmq"
    },{
        Name = "${local.ec2_name}-rabbitmq"
    })
}

resource "null_resource" "rabbitmq" {
  triggers = {
    instance_id = module.rabbitmq.id
  }

  connection {
    host = module.rabbitmq.private_ip
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
      "sudo /tmp/bootstrap.sh rabbitmq dev" # you need to provide the arguments for shell script
    ]
  }
}

# gist 
# create an instance and triggering a null resouce instead of user data because userdata executables are not visible(we copy the file to the instance from local to execute it)

# route 53 record set
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  
  zone_name = var.zone_name

  records = [
    {
      name    = "mongodb-dev"
      type    = "A"
      ttl     = 1
      records = [
        module.mongodb.private_ip,
      ]
    },{
      name    = "redis-dev"
      type    = "A"
      ttl     = 1
      records = [
        module.redis.private_ip,
      ]
    },{
      name    = "mysql-dev"
      type    = "A"
      ttl     = 1
      records = [
        module.mysql.private_ip,
      ]
    },{
      name    = "rabbitmq-dev"
      type    = "A"
      ttl     = 1
      records = [
        module.rabbitmq.private_ip,
      ]
    },
  ]
}