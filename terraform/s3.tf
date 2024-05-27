resource "aws_s3_bucket" "bta_panel" {
  bucket = "corbinmcbtacontrolpanel"
}

resource "aws_s3_bucket_public_access_block" "bta_panel" {
  bucket = aws_s3_bucket.bta_panel.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "bta_panel" {
  bucket = aws_s3_bucket.bta_panel.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  depends_on = [aws_s3_bucket_public_access_block.bta_panel]
}

resource "aws_s3_bucket_acl" "bta_panel" {
  bucket = aws_s3_bucket.bta_panel.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.bta_panel]
}

resource "aws_s3_bucket_policy" "bta_panel_oac_access" {
  bucket = aws_s3_bucket.bta_panel.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "AllowGetObjects"
    Statement = [
      {
        Sid       = "AllowOAC"
        Effect    = "Allow"
        Principal = { "AWS" : [aws_cloudfront_distribution.bta_panel.arn] }
        Action    = "s3:GetObject"
        Resource = [
          "${aws_s3_bucket.bta_panel.arn}",
          "${aws_s3_bucket.bta_panel.arn}/*"
        ]
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.bta_panel,
    aws_cloudfront_origin_access_control.bta_panel
  ]
}

module "bta_panel_web_files" {
  source = "hashicorp/dir/template"

  base_dir = "${path.module}/../web"
}

resource "aws_s3_object" "bta_panel_web_files" {
  for_each = module.bta_panel_web_files.files

  bucket       = aws_s3_bucket.bta_panel.id
  key          = each.key
  content_type = each.value.content_type

  source  = each.value.source_path
  content = each.value.content

  etag = each.value.digests.md5
}
