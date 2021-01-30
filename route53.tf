data "aws_route53_zone" "profile" {
  name = var.domain
}

resource "aws_route53_record" "www-profile" {
  name    = "www.${var.domain}"
  type    = "A"
  zone_id = data.aws_route53_zone.profile.zone_id

  alias {
    name                   = aws_cloudfront_distribution.profile.domain_name
    zone_id                = aws_cloudfront_distribution.profile.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "profile" {
  name    = var.domain
  type    = "A"
  zone_id = data.aws_route53_zone.profile.zone_id

  alias {
    name                   = aws_cloudfront_distribution.profile.domain_name
    zone_id                = aws_cloudfront_distribution.profile.hosted_zone_id
    evaluate_target_health = false
  }
}