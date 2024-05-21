resource "aws_route53_zone" "main" {
  name = "bta.corbinpersonal.me"
}

resource "aws_route53_record" "server_cname" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "play.bta.corbinpersonal.me"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_instance.bta.public_dns]
}
