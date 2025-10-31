output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.myvpc.id
}

output "public_subnet_ids" {
  description = "A list of IDs of the public subnets."
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "A list of IDs of the private subnets."
  value       = aws_subnet.private_subnets[*].id
}

output "default_security_group_id" {
  description = "The ID of the default security group."
  value       = aws_security_group.default_sg.id
}