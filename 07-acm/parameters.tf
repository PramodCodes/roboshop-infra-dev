# we need to export the ACM certificate ARN to SSM parameter
resource "aws_ssm_parameter" "acm_certificate_arn" {
  name = "/${var.project_name}/${var.environment}/acm_certificate_arn"
  description = "acm certificate arn"
  type        = "String"
  value       = aws_acm_certificate.pka.arn
}