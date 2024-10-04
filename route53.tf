resource "aws_acm_certificate" "acm_project" {
  domain_name       = "balagangadharanath.site"
  validation_method = "DNS"
}

data "aws_route53_zone" "route_project" {
  name         = "balagangadharanath.site"
  private_zone = false
}

resource "aws_route53_record" "route53_project" {
  for_each = {
    for dvo in aws_acm_certificate.acm_project : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.route_project.zone_id
}

resource "aws_acm_certificate_validation" "validation_project" {
  certificate_arn         = aws_acm_certificate.acm_project.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_project : record.fqdn]
}

resource "aws_lb_listener" "listener_lb" {
  # ... other configuration ...

  certificate_arn = aws_acm_certificate_validation.validation_project.certificate_arn
}