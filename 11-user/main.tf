module "user" {

  source = "../../terraform-roboshop-app"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
 component_sg_id = data.aws_ssm_parameter.user_sg_id.value
 private_subnets_ids = split(",", data.aws_ssm_parameter.private_subnets_ids.value) # lets send list from here
 iam_instance_profile = var.iam_instance_profile
}
