# Must give 2 or more subnets in different AZs
alb_subnets = [
  "subnet-xx-1", "subnet-xx-2"
]

# Where ASGs will launch instances (private subnets typically)
asg_subnets = [
  "subnet-xx-1",
  "subnet-xx-2"
]

# Optional: if you want to pin AMI
#ami_id = "any-ami-id"
instance_type  = "t3.micro"
key_pair_name  = "your-key-pair"
allowed_ssh_cidr = "xx.xx.xx/32" # Allow only a single ip

alb_name = "prod-my-alb"

# You can override context_paths here if you like
context_paths = {
  cars   = "/cars*"
  bikes  = "/bikes*"
  trucks = "/trucks*"
}

# optionally create a few static instances (not required if ASGs suffice)
instance_mapping = {
  "static-home-1" = "homepage"
  # "static-cars-1" = "cars"
}
