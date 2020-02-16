resource "aws_cloudfront_distribution" "static_site" {

  provider = var.cloudflont_region

  aliases = [
    var.sub_domain_name == "" ? var.main_domain_name : "${var.sub_domain_name}.${var.main_domain_name}"]

  origin {
    domain_name = aws_s3_bucket.static_site.bucket_regional_domain_name
    origin_id = "S3-${var.bucket_name}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.static_site_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",]
    cached_methods = [
      "GET",
      "HEAD"]
    compress = false
    target_origin_id = "S3-${var.bucket_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_200"

  custom_error_response {
    error_caching_min_ttl = 300
    error_code = 403
    response_code = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code = 404
    response_code = 404
    response_page_path = "/index.html"
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn = var.acm_certificate_arn["main_arn"]
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}