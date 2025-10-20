resource "random_string" "random" {
  length = 4
  special = false
  upper = false
}
resource "aws_s3_bucket" "mys3" {
  bucket = "${var.bucket_name}-${random_string.random.result}"
  force_destroy = true
}
