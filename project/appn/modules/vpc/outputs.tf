output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}
output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}
output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.allow_all.id
}
output "pub_availability_zone" {
  description = "The availability zone of the public subnet"
  value       = aws_subnet.public_subnet.availability_zone
}
