resource "aws_s3_bucket" "profile" {
  bucket = "www.${var.domain}"
  acl    = "private"

  website {
    error_document = "error.html"
    index_document = "index.html"
  }
}

data "aws_iam_policy_document" "profile" {
  statement {
    sid = "PublicReadGetObject"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.profile.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.profile.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "profile" {
  bucket = aws_s3_bucket.profile.bucket
  policy = data.aws_iam_policy_document.profile.json
}
