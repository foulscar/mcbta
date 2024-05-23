resource "aws_s3_bucket" "bta_panel" {
  bucket = "corbinmcbtacontrolpanel"
}

resource "aws_s3_bucket_acl" "bta_panel" {
  bucket = aws_s3_bucket.bta_panel.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "bta_panel" {
  bucket = aws_s3_bucket.bta_panel.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "bta_panel" {
  bucket = aws_s3_bucket.bta_panel.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "AllowGetObjects"
    Statement = [
      {
        Sid       = "AllowPublic"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.bta_panel.arn}/**"
      }
    ]
  })
}

module "bta_panel_web_files" {
  source = "hashicorp/dir/template"

  base_dir = "${path.module}/../web"
}

resource "aws_s3_bucket_object" "bta_panel_web_files" {
  for_each = module.bta_panel_web_files.files

  bucket       = aws_s3_bucket.bta_panel.id
  key          = each.key
  content_type = each.value.content_type

  source  = each.value.source_path
  content = each.value.content

  etag = each.value.digests.md5
}
