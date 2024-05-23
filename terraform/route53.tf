resource "aws_route53_zone" "main" {
  name = "bta.corbinpersonal.me"
}

resource "aws_route53_record" "server_cname" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "play.bta.corbinpersonal.me"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.bta.public_ip]
}

resource "aws_route53_record" "bta_api_cert_record" {
  for_each = {
    for dvo in aws_acm_certificate.bta_api.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.main.zone_id
}

resource "aws_route53_record" "bta_panel_cert_record" {
  for_each = {
    for dvo in aws_acm_certificate.bta_panel.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.main.zone_id
}
