# ---------------------------------------------------------------------------------------------------------------------
# AWS Provider Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "vpc_name" {
  description = "The name for the VPC."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
}



# ---------------------------------------------------------------------------------------------------------------------
# Load Balancer & EC2 Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "instance_type" {
  description = "The EC2 instance type for the application servers."
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "The name of the EC2 key pair to use for SSH access."
  type        = string
}

variable "alb_name" {
  description = "The name for the Application Load Balancer."
  type        = string
}

variable "operator_email" {
  description = "Email address for notifications."
  type        = string
}

variable "homepage_asg" {
  type = object({
    min_size         = number
    desired_capacity = number
    max_size         = number
    cpu_target_value = number
  })
  default = {
    min_size         = 1
    desired_capacity = 2
    max_size         = 3
    cpu_target_value = 50
  }
}

variable "per_tg_asg_defaults" {
  type = object({
    min_size         = number
    desired_capacity = number
    max_size         = number
    cpu_target_value = number
  })
  default = {
    min_size         = 1
    desired_capacity = 1
    max_size         = 2
    cpu_target_value = 50
  }
}

variable "per_tg_asg_config" {
  description = "Specific override configurations for path-based ASGs. Any path defined here will use these settings instead of the defaults."
  type = map(object({
    min_size         = number
    desired_capacity = number
    max_size         = number
    cpu_target_value = number
  }))
  default = {}
}