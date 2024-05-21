resource "aws_route53_zone" "main" {
  name = "bta.corbinpersonal.me"
}

resource "aws_route53_record" "ns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "bta.corbinpersonal.me"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.main.name_servers
}

resource "aws_route53_record" "server_cname" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "play.bta.corbinpersonal.me"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_instance.bta.public_dns]
}
