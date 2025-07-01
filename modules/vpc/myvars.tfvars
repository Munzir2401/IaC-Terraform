/*vpc variables*/
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
