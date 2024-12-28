resource "aws_lb" "app_alb" {
  name               = "${local.name}-${var.tags.Componenet}" # we need roboshop-dev-app-alb here
  internal           = true # app alb sits between applications so internal 
  load_balancer_type = "application"
  # app alb should be internal and only accept vpn traffic
  # load balancer has a condition for in how many subnets it should be created
  security_groups    = [data.aws_ssm_parameter.vpc_id.value]
  subnets            = split(",",data.aws_ssm_parameter.priavte_subnets_ids.value)

  # enable_deletion_protection = true #because we need to delete after the class
  tags = merge(
    var.common_tags,
    var.tags
  )
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hi this Fixed response is from ALB"
      status_code  = "200"
    }
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  
  zone_name = var.zone_name

  records = [
    {
      name    = "*.app-${var.environment}"
      type    = "A"
      ttl     = 1
      records = [
        module.mongodb.private_ip,
      ]
      alias = {
        name    = aws_lb.app_alb.dns_name
        zone_id = aws_lb.app_alb.zone_id
      }
    }
  ]
}