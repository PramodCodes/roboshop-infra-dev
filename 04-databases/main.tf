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
# how we will know if userdata is success or failure ? we cannot so we will use terraform provisioners
# we can use null resource in terraform to connect with terraform provisioners , null resource means 
# it will not create any resource but it will run the provisioners and it is not related to any provisioners
resource "null_resource" "mongodb" {

  triggers = {
    instance_id = module.mongodb.id
  }

  connection {
    host = module.mongodb.id
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
      "sudo /tmp/bootstrap.sh"
    ]
  }
}
# gist 
# create an instance and triggering a null resouce instead of user data because userdata executables are not visible(we copy the file to the instance from local to execute it)

