terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.96.0"
    }
  }
  backend "s3" {
    bucket = "your-bucket-name"
    # The bucket name must be globally unique across all AWS accounts
    key    = "your-key"
    encrypt = true
    region = "ap-south-1"
    use_lockfile = true
    acl     = "private"
  }
}



provider "aws" {
  region = "ap-south-1"
}
# The above code is a Terraform configuration file that sets up the AWS provider and specifies the region to be used for resources.
