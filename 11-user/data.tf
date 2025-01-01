
data "aws_ssm_parameter" "vpc_id" {
    name  = "/${var.project_name}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "user_sg_id" {
    name  = "/${var.project_name}/${var.environment}/user_sg_id"
}

data "aws_ssm_parameter" "private_subnets_ids" {
    name  = "/${var.project_name}/${var.environment}/private_subnets_ids"
}
data "aws_ssm_parameter" "app_alb_listner_arn" {
    name  = "/${var.project_name}/${var.environment}/app_alb_listner_arn"
}