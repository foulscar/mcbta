resource "aws_cloudfront_distribution" "bta_panel" {
  enabled = true

  aliases = ["panel.bta.corbinpersonal.me"]

  origin {
    origin_id   = "${aws_s3_bucket.bta_panel.id}-origin"
    domain_name = aws_s3_bucket_website_configuration.bta_panel.website_domain
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1"]
    }
  }

  default_cache_behavior {
    target_origin_id = "${aws_s3_bucket.bta_panel.id}-origin"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.bta_panel.arn
    ssl_support_method  = "sni-only"
  }

  price_class = "PriceClass_100"

  depends_on = [aws_acm_certificate_validation.bta_panel]
}
