/*vpc variables*/
variable "cidr_block" {
  description = "The CIDR block for the VPC"
  }
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  }
variable "igw_name" {
  description = "The name of the Internet Gateway"
  type        = string
  }
variable "sub_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  }
variable "pub_route_table" {
  description = "The name of the public route table"
  type        = string    
  }
variable "priv_route_table" {
  description = "The name of the private route table"
  type        = string
  }
variable "pub_sub_cidr" {
  description = "The CIDR block for the public subnet"                                              
  type        = string
  }
variable "priv_sub_cidr" {
  description = "The CIDR block for the priv subnet"                                              
  type        = string
  }
variable "pub_availability_zone" {
  description = "The availability zone for the public subnet"
  }
variable "priv_availability_zone" {
  description = "The availability zone for the private subnet"
  }
variable "pub_sub_name" {
  description = "The name of the public subnet"
  type        = string
  }
variable "priv_sub_name" {
  description = "The name of the private subnet"
  type        = string
  }
variable "security_group_name" {
  description = "The name of the security group to create"
  type        = string
  }
  
