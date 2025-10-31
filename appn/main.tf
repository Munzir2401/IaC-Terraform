/* vpc module */
module "vpc" {
  source = "./modules/vpc"

  vpc_name             = var.vpc_name
  cidr_block           = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  # Pass the first two available AZs to the VPC module.
  # This makes the configuration portable to any region without hardcoding AZ names.
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 2)
}

/* load_balancer module */
module "load_balancer" {
  source = "./modules/load_balancer"

  vpc_id                = module.vpc.vpc_id
  alb_subnets           = module.vpc.public_subnet_ids
  asg_subnets           = module.vpc.private_subnet_ids
  log_bucket_name       = module.s3_log_bucket.bucket_id
  instance_type         = var.instance_type
  key_pair_name         = var.key_pair_name
  alb_name              = var.alb_name
  operator_email        = var.operator_email

  # Pass the ASG configurations to the module
  homepage_asg          = var.homepage_asg
  per_tg_asg_defaults   = var.per_tg_asg_defaults
  per_tg_asg_config     = var.per_tg_asg_config
}

/* s3_log_bucket module */
module "s3_log_bucket" {
  source      = "./modules/s3_log_bucket"
  bucket_name = "my-app-alb-logs-${random_id.this.hex}"
}

resource "random_id" "this" {
  byte_length = 8
}

# ---------------------------------------------------------------------------------------------------------------------
# Data Sources
# ---------------------------------------------------------------------------------------------------------------------

# Get a list of all available Availability Zones in the current region.
data "aws_availability_zones" "available" {
  state = "available"
}
