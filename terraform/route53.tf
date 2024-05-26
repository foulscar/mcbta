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

resource "aws_route53_record" "bta_api" {
  name    = aws_apigatewayv2_domain_name.bta.domain_name
  type    = "A"
  zone_id = aws_route53_zone.main.id

  alias {
    evaluate_target_health = true
    name                   = aws_apigatewayv2_domain_name.bta.cloudfront_domain_name
    zone_id                = aws_apigatewayv2_domain_name.bta.cloudfront_zone_id
  }
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

#resource "aws_route53_record" "bta_panel" {
#zone_id = aws_route53_zone.main.zone_id
#name    = "panel.bta.corbinpersonal.me"
#type    = "A"
#
#alias {
#name                   = aws_cloudfront_distribution.bta_panel.domain_name
#zone_id                = aws_cloudfront_distribution.bta_panel.hosted_zone_id
#evaluate_target_health = true
#}
#}
#
#resource "aws_route53_record" "bta_panel_cert_record" {
#for_each = {
#for dvo in aws_acm_certificate.bta_panel.domain_validation_options : dvo.domain_name => {
#name   = dvo.resource_record_name
#record = dvo.resource_record_value
#type   = dvo.resource_record_type
#}
#}
#
#allow_overwrite = true
#name            = each.value.name
#records         = [each.value.record]
#ttl             = 60
#type            = each.value.type
#zone_id         = aws_route53_zone.main.zone_id
#}
