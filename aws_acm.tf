resource "aws_acm_certificate" "example" {
  domain_name = "balagangadharanath.site"
  validation_method = "DNS"
  lifecycle {
    ignore_changes = [
      "validation_status"
    ]
  }
}