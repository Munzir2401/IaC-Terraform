terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.14.0"
    }
  }

backend "s3" {
    bucket         = "your-bucket-name"
    key            = "path-to-key"
    region         = "your-aws-region"
    use_lockfile   = true
    encrypt        = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "your-aws-region"
}
