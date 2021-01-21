locals {
  s3_origin_id = aws_s3_bucket.www-mybytesni-com.bucket
}

data "aws_acm_certificate" "mybytesni-com" {
  domain      = "mybytesni.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_cloudfront_distribution" "www-mybytesni-com" {
  enabled = true

  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  origin {
    domain_name = aws_s3_bucket.www-mybytesni-com.bucket_domain_name
    origin_id   = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.www-mybytesni-com.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.mybytesni-com.arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }

  aliases = [
    "www.mybytesni.com",
    "mybytesni.com"
  ]

  is_ipv6_enabled = true
}

resource "aws_cloudfront_origin_access_identity" "www-mybytesni-com" {
  comment = local.s3_origin_id
}
