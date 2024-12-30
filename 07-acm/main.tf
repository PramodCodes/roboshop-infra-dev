resource "aws_acm_certificate" "pka" {
  domain_name       = "*.pka.in.net"
  validation_method = "DNS"

  tags = merge( 
    var.tags,
    var.common_tags
  )
  
  lifecycle {
    create_before_destroy = true
  }
}
# validation of domain name is done by DNS method by creating a CNAME record in Route53
# gets certificates from aws and itereates over them to create a record in Route53
resource "aws_route53_record" "pka" {
  for_each = {
    for dvo in aws_acm_certificate.pka.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 1
  type            = each.value.type
  # this is our hosted zone
  zone_id         = data.aws_route53_zone.pka.zone_id
}

# validation of records for the domain name
resource "aws_acm_certificate_validation" "pka" {
  certificate_arn         = aws_acm_certificate.pka.arn //to check
  validation_record_fqdns = [for record in aws_route53_record.pka : record.fqdn]
}
# till 8:04 am -o-

