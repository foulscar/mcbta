resource "aws_acm_certificate" "bta_api" {
  domain_name = "api.bta.corbinpersonal.me"
  validation_method = "DNS"

  tags = {
    Name = "bta-api-cert"
  }
}
