resource "aws_s3_bucket" "static_site" {
  bucket        = "${terraform.workspace}-${var.bucket_name}"
  force_destroy = true
}

resource "aws_s3_bucket" "static_site_access_logs" {
  bucket        = "${terraform.workspace}-${var.bucket_static_site}-logs"
  force_destroy = true
}

data "aws_iam_policy_document" "static_site_s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static_site.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.static_site_origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "static_site" {
  bucket = aws_s3_bucket.static_site.id
  policy = data.aws_iam_policy_document.static_site_s3_policy.json
}

data "aws_iam_policy_document" "static_site_access_logs" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.static_site_access_logs.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.static_site_origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "static_site_access_logs" {
  bucket = aws_s3_bucket.static_site_access_logs.id
  policy = data.aws_iam_policy_document.static_site_access_logs.json
}

resource "aws_cloudfront_origin_access_identity" "static_site_origin_access_identity" {
  comment = "access-identity-S3-${terraform.workspace}-${var.bucket_static_site}"
}
