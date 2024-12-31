data "aws_ssm_parameter" "web_alb_sg_id" {
    name  = "/${var.project_name}/${var.environment}/web_alb_sg_id"
}

data "aws_ssm_parameter" "public_subnets_ids" {
    name  = "/${var.project_name}/${var.environment}/public_subnets_ids"
}
data "aws_ssm_parameter" "acm_certificate_arn" {
    name  = "/${var.project_name}/${var.environment}/acm_certificate_arn"
}
# this is for cloudfront
resource "aws_ssm_parameter" "web_alb_dns_name" {
  name  = "/${var.project_name}/${var.environment}/web_alb_dns_name"
  type  = "String"
  value = aws_lb.web.dns_name
}