resource "aws_lb" "web" {
  name               = "${local.name}-${var.tags.Componenet}" # we need roboshop-dev-app-alb here
  internal           = false # app alb faces traffic so false
  load_balancer_type = "application"
  # app alb should be external and accepts all traffic
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.public_subnets_ids.value)
  tags = merge(
    var.common_tags,
    var.tags
  )
}
# this is facing internet behind alb
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_ssm_parameter.acm_certificate_arn.value

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "This is from web alb https"
      status_code  = "200"
    }
  }
}


module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name

  records = [
    {
      name    = "web-${var.environment}"
      type    = "A"
      alias = {
        name    = aws_lb.web.dns_name
        zone_id = aws_lb.web.zone_id
      } 
    }
  ]
}