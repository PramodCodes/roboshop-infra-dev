module "payment" {

  # source               = "../../terraform-roboshop-app"
  source               = "git::https://github.com/PramodCodes/terraform-roboshop-app.git?ref=main"
  vpc_id               = data.aws_ssm_parameter.vpc_id.value
  component_sg_id      = data.aws_ssm_parameter.payment_sg_id.value
  private_subnets_ids  = split(",", data.aws_ssm_parameter.private_subnets_ids.value) # lets send list from here
  app_alb_listener_arn  = data.aws_ssm_parameter.app_alb_listener_arn.value
  rule_priority = 50
  iam_instance_profile = var.iam_instance_profile
  project_name         = var.project_name
  environment          = var.environment
  common_tags          = var.common_tags
  zone_name            = var.zone_name
  tags                 = var.tags
}
