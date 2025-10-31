output "bucket_id" {
  description = "The ID (name) of the S3 log bucket."
  value       = aws_s3_bucket.log_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the S3 log bucket."
  value       = aws_s3_bucket.log_bucket.arn
}
