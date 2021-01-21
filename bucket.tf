resource "aws_s3_bucket" "www-mybytesni-com" {
  bucket = "www.mybytesni.com"
  acl    = "private"

  website {
    error_document = "error.html"
    index_document = "index.html"
  }
}

data "aws_iam_policy_document" "www-mybytesni-com" {
  statement {
    sid = "PublicReadGetObject"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.www-mybytesni-com.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.www-mybytesni-com.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "www-mybytesni-com" {
  bucket = aws_s3_bucket.www-mybytesni-com.bucket
  policy = data.aws_iam_policy_document.www-mybytesni-com.json
}
