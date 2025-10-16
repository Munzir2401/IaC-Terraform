#########################
# General / AWS
#########################
variable "vpc_id" {
  type        = string
  description = "VPC id where ALB, instances and subnets exist (optional, data lookup used if empty)"
  default     = ""
}

#########################
# Networking
#########################
variable "alb_subnets" {
  description = "List of 2+ subnets (in different AZs) for the ALB and ASGs"
  type        = list(string)
  default     = []
}

variable "asg_subnets" {
  description = "List of subnets where ASG instances will be launched (preferably private subnets). If empty, alb_subnets will be used."
  type        = list(string)
  default     = []
}

#########################
# Instance/AMI
#########################
/*variable "ami_id" {
  description = "AMI ID to use for launch template. If empty, defaults to latest Amazon Linux 2 via data source."
  type        = string
  default     = ""
}*/

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_pair_name" {
  type    = string
  default = "your-key-pair"
}

variable "allowed_ssh_cidr" {
  description = "CIDR to allow SSH from (change for production)"
  type        = string
  default     = "0.0.0.0/0"
}

#########################
# ALB & TGs
#########################
variable "alb_name" {
  type    = string
  default = "my-alb"
}

variable "to_port" {
  type    = number
  default = 80
}

variable "conn_protocol" {
  type    = string
  default = "HTTP"
}

variable "target_type" {
  type    = string
  default = "instance"
}

variable "context_paths" {
  type = map(string)
  default = {
    cars   = "/cars*"
    bikes  = "/bikes*"
    trucks = "/trucks*"
  }
}

#########################
# Instance mapping (optional static instances)
#########################
# If you want a set of named single instances to exist (not required if ASGs cover all)
variable "instance_mapping" {
  type    = map(string)
  default = {}
}

#########################
# Autoscaling
#########################
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
    desired_capacity = 2
    max_size         = 3
    cpu_target_value = 60
  }
}

#########################
# Bootstrapping
#########################
variable "user_data_install" {
  type    = string
  default = <<-EOF
              #!/bin/bash
              # Bootstrap: install nginx, create default page, and create path-based pages
              yum update -y
              amazon-linux-extras enable nginx1
              yum install -y nginx
              
              # Create the default homepage
              echo "<html><body><h1>Welcome from Homepage: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</h1></body></html>" > /usr/share/nginx/html/index.html

              # Create directories and index files for each context path
              # This ensures health checks for /cars, /bikes, etc. will pass
              for path in cars bikes trucks; do
                mkdir -p /usr/share/nginx/html/$path
                echo "<html><body><h1>Welcome from $path: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</h1></body></html>" > /usr/share/nginx/html/$path/index.html
              done

              systemctl enable nginx
              systemctl start nginx
            EOF
}

