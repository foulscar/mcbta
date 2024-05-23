resource "aws_acm_certificate" "bta_api" {
  domain_name       = "api.bta.corbinpersonal.me"
  validation_method = "DNS"

  tags = {
    Name = "bta-api-cert"
  }
}

resource "aws_acm_certificate_validation" "bta_api" {
  certificate_arn         = aws_acm_certificate.bta_api.arn
  validation_record_fqdns = [for record in aws_route53_record.bta_api_cert_record : record.fqdn]
}
