data "aws_iam_policy_document" "github-actions" {
  statement {
    sid = "S3ListBucket"
    actions = [
      "s3:ListBucket"
    ]
    resources = [aws_s3_bucket.www-mybytesni-com.arn]
    effect = "Allow"
  }

  statement {
    sid = "S3PutObject"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.www-mybytesni-com.arn}/*"]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "github-actions" {
  name = "github-actions-for-www-mybytesni-com"
  description = "Allows github write to the www.mybytesni.com s3 bucket"
  policy = data.aws_iam_policy_document.github-actions.json
}

resource "aws_iam_user" "github-actions" {
  name = "github-actions-for-www-mybytesni-com"
}

resource "aws_iam_user_policy_attachment" "github-actions" {
  policy_arn = aws_iam_policy.github-actions.arn
  user = aws_iam_user.github-actions.id
}
