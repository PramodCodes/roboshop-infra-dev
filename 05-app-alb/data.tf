data "aws_ssm_parameter" "vpc_id" {
    name  = "/${var.project_name}/${var.environment}/app_alb_sg_id"
}
data "aws_ssm_parameter" "priavte_subnets_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnets_ids"
}