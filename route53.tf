data "aws_route53_zone" "mybytesni-com" {
  name = "mybytesni.com"
}

resource "aws_route53_record" "www-mybytesni-com" {
  name    = "www.mybytesni.com"
  type    = "A"
  zone_id = data.aws_route53_zone.mybytesni-com.zone_id

  alias {
    name                   = aws_cloudfront_distribution.www-mybytesni-com.domain_name
    zone_id                = aws_cloudfront_distribution.www-mybytesni-com.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "mybytesni-com" {
  name    = "mybytesni.com"
  type    = "A"
  zone_id = data.aws_route53_zone.mybytesni-com.zone_id

  alias {
    name                   = aws_cloudfront_distribution.www-mybytesni-com.domain_name
    zone_id                = aws_cloudfront_distribution.www-mybytesni-com.hosted_zone_id
    evaluate_target_health = false
  }
}