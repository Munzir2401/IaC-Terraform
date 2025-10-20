/* vpc module */

module "vpc" {

source = "./modules/vpc"
cidr_block = "75.40.0.0/16"
vpc_name = "my-vpc"
igw_name = "my-igw"
sub_cidr = "0.0.0.0/0"
pub_route_table = "public-route-table"
priv_route_table = "private-route-table"
pub_sub_cidr = "75.40.0.0/24" # This is a public subnet CIDR block
# The CIDR block for the public subnet is a subset of the VPC CIDR block
priv_sub_cidr = "75.40.1.0/24" # This is a private subnet CIDR block
# The CIDR block for the private subnet is a subset of the VPC CIDR block
pub_availability_zone = "ap-south-1a"
priv_availability_zone = "ap-south-1b"
pub_sub_name = "my-public-subnet" 
priv_sub_name = "my-private-subnet"
security_group_name = "my-security-group" # The name of the security group to create

}

/* ec2 module */
data "aws_ami" "myami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

/*variable "instance_details" {
  type = map(object({
    name          = string
    key_name      = string
    instance_type = string
  }))
}*/

module "ec2" {
source = "./modules/ec2"
ebs_name = "my-ebs-volume" # The name of the EBS volume
instance_volume_size = 8 # The size of the EBS volume in GB
instance_volume_type = "gp3" # The type of EBS volume to create
public_subnet_id = module.vpc.public_subnet_id # The public subnet ID
private_subnet_id = module.vpc.private_subnet_id # The private subnet ID
security_group_id = module.vpc.security_group_id # The ID of the security group
availability_zone = module.vpc.pub_availability_zone # Default to Mumbai region (ap-south-1a)
instance_details = {
  instance1 = {
    name          = "app-server"
    key_name      = "new_freelancer_key_pair" # The name of the key pair to use for SSH access
    instance_type = "t3.micro" # The type of EC2 instance to create
  }
  instance2 = {
    name          = "db-server"
    key_name      = "new_freelancer_key_pair" # The name of the key pair to use for SSH access
    instance_type = "t3.micro" # The type of EC2 instance to create
  }
  instance3 = {
    name          = "web-server"
    key_name      = "new_freelancer_key_pair" # The name of the key pair to use for SSH access
    instance_type = "t3.micro" # The type of EC2 instance to create
  }
  instance4 = {
    name          = "cache-server"
    key_name      = "new_freelancer_key_pair" # The name of the key pair to use for SSH access
    instance_type = "t3.micro" # The type of EC2 instance to create               
  }
  instance5 = {
    name          = "load-balancer"
    key_name      = "new_freelancer_key_pair" # The name of the key pair to use for SSH access
    instance_type = "t3.micro" # The type of EC2 instance to create
  }
}
}