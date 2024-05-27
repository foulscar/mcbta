resource "aws_cloudfront_distribution" "bta_panel" {
  enabled = true

  aliases = ["panel.bta.corbinpersonal.me"]

  origin {
    origin_id                = "${aws_s3_bucket.bta_panel.id}-origin"
    domain_name              = aws_s3_bucket.bta_panel.bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.bta_panel.id
  }

  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = "${aws_s3_bucket.bta_panel.id}-origin"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
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

resource "aws_cloudfront_origin_access_control" "bta_panel" {
  name                              = "bta_panel"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
