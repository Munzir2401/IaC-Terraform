data "terraform_remote_state" "vpc" {
  backend = "s3"
  
  config = {
    bucket = "bucket-name"
    key    = "path/to/terraform/tf.state" # Match your VPC state path
    region = "ap-south-1"
  }
}

data "terraform_remote_state" "ec2" {
  backend = "s3"
  
  config = {
    bucket = "bucket-name"
    key    = "path/to/terraform/tf.state" # Match your EC2 state path
    region = "ap-south-1"
  }
}
