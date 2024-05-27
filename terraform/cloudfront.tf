resource "aws_cloudfront_distribution" "bta_panel" {
  enabled = true

  aliases = ["panel.bta.corbinpersonal.me"]

  origin {
    origin_id   = "${aws_s3_bucket.bta_panel.id}-origin"
    domain_name = aws_s3_bucket.bta_panel.bucket_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.bta_panel.cloudfront_access_identity_path
    }
  }

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

resource "aws_cloudfront_origin_access_identity" "bta_panel" {
  comment = "BTA Control Panel"
}
