locals {
  s3_origin_id = aws_s3_bucket.profile.bucket
}

data "aws_acm_certificate" "profile" {
  domain      = var.domain
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_cloudfront_distribution" "profile" {
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
    domain_name = aws_s3_bucket.profile.bucket_domain_name
    origin_id   = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.profile.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.profile.arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }

  aliases = [
    var.domain,
    "www.${var.domain}"
  ]

  is_ipv6_enabled = true
}

resource "aws_cloudfront_origin_access_identity" "profile" {
  comment = local.s3_origin_id
}
