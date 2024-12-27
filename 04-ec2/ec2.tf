# instances creation for db tier
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

module "redis" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id

  name = "${local.ec2_name}-redis"

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

module "mysql" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id

  name = "${local.ec2_name}-mysql"

  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    {
        Componenet = "mysql"
    },{
        Name = "${local.ec2_name}-mysql"
    })
}
module "rabbitmq" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id

  name = "${local.ec2_name}-rabbitmq"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    {
        Componenet = "rabbitmq"
    },{
        Name = "${local.ec2_name}-rabbitmq"
    })
}

# microservices tier
# - catalogue
# - user
# - cart
# - shipping
# - payment
module "catalogue" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id

  name = "${local.ec2_name}-catalogue"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    {
        Componenet = "catalogue"
    },{
        Name = "${local.ec2_name}-catalogue"
    })
}
module "user" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id

  name = "${local.ec2_name}-catalogue"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.user_sg_id.value]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    {
        Componenet = "user"
    },{
        Name = "${local.ec2_name}-user"
    })
}
module "cart" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id

  name = "${local.ec2_name}-cart"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.cart_sg_id.value]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    {
        Componenet = "cart"
    },{
        Name = "${local.ec2_name}-cart"
    })
}
module "shipping" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id

  name = "${local.ec2_name}-shipping"

  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.shipping_sg_id.value]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    {
        Componenet = "shipping"
    },{
        Name = "${local.ec2_name}-shipping"
    })
}
module "payment" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id

  name = "${local.ec2_name}-payment"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.payment_sg_id.value]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    {
        Componenet = "payment"
    },{
        Name = "${local.ec2_name}-payment"
    })
}

# web tier
module "web" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name = "${local.ec2_name}-web"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.web_sg_id.value]
  subnet_id              = local.public_subnet_id

  tags = merge(
    var.common_tags,
    {
        Componenet = "web"
    },{
        Name = "${local.ec2_name}-web"
    })
}

# configuration layer with ansible

module "ansible" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name = "${local.ec2_name}-ansible"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  # we are creating this in default vpn's 1a subnet
  subnet_id              = data.aws_subnet.default_vpc_subnet.id
  user_data = file("ec2-provision.sh")
  tags = merge(
    var.common_tags,
    {
        Componenet = "ansible"
    },{
        Name = "${local.ec2_name}-ansible"
    })
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name

  records = [
    {
      name    = "mongodb"
      type    = "A"
      ttl     = 1
      records = [
        # this is from ec2 instance in the same tf file
        "${module.mongodb.private_ip}",
      ]
    },{
      name    = "redis"
      type    = "A"
      ttl     = 1
      records = [
        "${module.redis.private_ip}",
      ]
    },{
      name    = "mysql"
      type    = "A"
      ttl     = 1
      records = [
        "${module.mysql.private_ip}",
      ]
    },{
      name    = "rabbitmq"
      type    = "A"
      ttl     = 1
      records = [
        "${module.rabbitmq.private_ip}",
      ]
    },{
      name    = "catalogue"
      type    = "A"
      ttl     = 1
      records = [
        "${module.catalogue.private_ip}",
      ]
    },{
      name    = "user"
      type    = "A"
      ttl     = 1
      records = [
        "${module.user.private_ip}",
      ]
    },{
      name    = "cart"
      type    = "A"
      ttl     = 1
      records = [
        "${module.cart.private_ip}",
      ]
    },{
      name    = "shipping"
      type    = "A"
      ttl     = 1
      records = [
        "${module.shipping.private_ip}",
      ]
    },{
      name    = "payment"
      type    = "A"
      ttl     = 1
      records = [
        "${module.payment.private_ip}",
      ]
    },{
      name    = "web"
      type    = "A"
      ttl     = 1
      records = [
        "${module.web.private_ip}",
      ]
    },{
      name    = ""
      type    = "A"
      ttl     = 1
      records = [
        "${module.web.public_ip}",
      ]
    },
    {
      name    = "ansible"
      type    = "A"
      ttl     = 1
      records = [
        "${module.ansible.public_ip}",
      ]
    },
  ]
}