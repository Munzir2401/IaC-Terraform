# Must give 2 or more subnets in different AZs
alb_subnets = [
  "subnet-xxxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxxx"
]

# Where ASGs will launch instances (private subnets typically)
asg_subnets = [
  "subnet-xxxxxxxxxxxxxxxx",
  "subnet-xxxxxxxxxxxxxxxx"
]

# Optional: if you want to pin AMI
#ami_id = "ami-0abcd1234efgh5678"

instance_type  = "t3.micro"
key_pair_name  = "your-key-pair-name"
allowed_ssh_cidr = "your-ip-address/32" # restrict SSH access

alb_name = "prod-my-alb"

# You can override context_paths here if you like
context_paths = {
  cars   = "/cars*"
  bikes  = "/bikes*"
  /*trucks = "/trucks*"*/
}

# Override ASG settings for specific context paths
per_tg_asg_config = {
  "cars" = {
    min_size         = 2
    desired_capacity = 2
    max_size         = 4
    cpu_target_value = 40
  }
  /*"bikes" = {
    min_size         = 1
    desired_capacity = 2
    max_size         = 3
    cpu_target_value = 60
  }
  "trucks" = {
    min_size         = 1
    desired_capacity = 2
    max_size         = 3
    cpu_target_value = 70
  }*/
}

# optionally create a few static instances (not required if ASGs suffice)
instance_mapping = {
  "static-home-1" = "homepage"
  # "static-cars-1" = "cars"
}
