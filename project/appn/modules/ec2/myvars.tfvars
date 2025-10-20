ebs_name = "my-ebs-volume" # The name of the EBS volume
instance_volume_size = 8 # The size of the EBS volume in GB
instance_volume_type = "gp3" # The type of EBS volume to create
public_subnet_id = "value" # The public subnet ID
private_subnet_id = "value" # The private subnet ID
security_group_id = "value_of_security_group_id" # The ID of the security group
availability_zone = "ap-south-1a" # Default to Mumbai region (ap-south-1a)
instance_details = {
  instance1 = {
    name          = "app-server"
    key_name      = "your-pem-key-name" # The name of the key pair to use for SSH access
    instance_type = "t2.micro" # The type of EC2 instance to create
  }
  instance2 = {
    name          = "db-server"
    key_name      = "your-pem-key-name" # The name of the key pair to use for SSH access
    instance_type = "t2.micro" # The type of EC2 instance to create
  }
  instance3 = {
    name          = "web-server"
    key_name      = "your-pem-key-name" # The name of the key pair to use for SSH access
    instance_type = "t2.micro" # The type of EC2 instance to create
  }
  instance4 = {
    name          = "cache-server"
    key_name      = "your-pem-key-name" # The name of the key pair to use for SSH access
    instance_type = "t2.micro" # The type of EC2 instance to create               
  }
  instance5 = {
    name          = "load-balancer"
    key_name      = "your-pem-key-name" # The name of the key pair to use for SSH access
    instance_type = "t3.medium" # The type of EC2 instance to create
  }
}
