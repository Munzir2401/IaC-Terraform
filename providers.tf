terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.14.0"
    }
  }

backend "s3" {
    bucket         = "munzir24"
    key            = "load-balancer/terraform/modular/tf.state"
    region         = "ap-south-1"
    use_lockfile   = true
    encrypt        = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}