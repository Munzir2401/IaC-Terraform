variable "ebs_name" {
  description = "The name of the EBS volume"
  type        = string
  }
variable "instance_volume_size" {
  description = "The size of the EBS volume in GB"
  type        = number
  }
variable "instance_volume_type" {
  description = "The type of EBS volume to create"
  type        = string
  }
variable "availability_zone" {
  description = "The availability zone for the EC2 instance"
  type        = string
  }
variable "instance_details" {
  description = "Details of the EC2 instances to create"
  type = map(object({
    instance_type = string
    name          = string
    key_name      = string
  }))
}
variable "security_group_id" {
}
variable "public_subnet_id" {
  description = "The ID of the public subnet"
  type        = string
}
variable "private_subnet_id" {
  description = "The ID of the private subnet"
  type        = string
}
