resource "aws_s3_bucket" "log_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = data.aws_iam_policy_document.log_bucket_policy_doc.json
}

data "aws_elb_service_account" "this" {}

data "aws_iam_policy_document" "log_bucket_policy_doc" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.this.arn]
    }
    actions   = ["s3:PutObject"]
    # This path must match the prefix configured in the load balancer module
    resources = ["${aws_s3_bucket.log_bucket.arn}/alb-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
  }
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_public_access_block" "log_bucket_access_block" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
