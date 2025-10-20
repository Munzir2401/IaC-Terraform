# Fetch the latest Amazon Linux 2 AMI
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"] # Owned by Amazon
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # Amazon Linux 2 AMI
  }
}
resource "aws_instance" "myec2" {
  ami           = data.aws_ami.latest_amazon_linux.id # Use the dynamically fetched AMI
  for_each      = var.instance_details # Iterate over the map of instance types
  subnet_id     = contains(["instance1", "instance3", "instance4", "instance5"], each.key) ? var.public_subnet_id : var.private_subnet_id # Use the appropriate subnet ID
  associate_public_ip_address = contains(["instance1", "instance3", "instance4", "instance5"], each.key) ? true : false # Public IP only for public subnet instances
  key_name      = each.value.key_name # Use the key name from the map
  instance_type = each.value.instance_type # Removed duplicate definition
  vpc_security_group_ids = [var.security_group_id] # Use the security group ID from the variable as a list
  tags = {
    Name = each.value.name # Use the name from the map
  }
}
