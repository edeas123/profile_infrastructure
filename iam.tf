data "aws_iam_policy_document" "github-actions" {
  statement {
    sid = "S3ListBucket"
    actions = [
      "s3:ListBucket"
    ]
    resources = [aws_s3_bucket.profile.arn]
    effect = "Allow"
  }

  statement {
    sid = "S3PutObject"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.profile.arn}/*"]
    effect = "Allow"
  }

  statement {
    sid = "CreateInvalidation"
    actions = [
      "cloudfront:CreateInvalidation"
    ]
    resources = [aws_cloudfront_distribution.profile.arn]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "github-actions" {
  name = "github-actions-for-profile"
  description = "Allows github write to the www.${var.domain} s3 bucket and invalidate cloudfront cache"
  policy = data.aws_iam_policy_document.github-actions.json
}

resource "aws_iam_user" "github-actions" {
  name = "github-actions-for-profile"
}

resource "aws_iam_user_policy_attachment" "github-actions" {
  policy_arn = aws_iam_policy.github-actions.arn
  user = aws_iam_user.github-actions.id
}
