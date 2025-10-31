variable "db_allocated_storage" {
  description = "The amount of storage (in GB) to allocate for the RDS instance"
  type        = number
}
variable "db_storage_type" {
  description = "The storage type for the RDS instance"
  type        = string
  default     = "gp2"
}
variable "db_max_allocated_storage" {
  description = "The maximum amount of storage (in GB) to allow for the RDS instance"
  type        = number
  default     = 100
}
variable "db_name" {
  description = "The name of the database to create"
  type        = string
}
variable "db_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
}
variable "db_engine" {
  description = "The database engine to use"
  type        = string
  default     = "mysql"
}
variable "db_engine_version" {
  description = "The version of the database engine to use"
  type        = string
  default     = "8.0"
}
variable "db_instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}
variable "db_username" {
  description = "The username for the database"
  type        = string
}
/*variable "db_password" {
  description = "The password for the database"
  type        = string
}*/
variable "db_parameter_group_name" {
  description = "The name of the DB parameter group to associate with the RDS instance"
  type        = string
  default     = "default.mysql8.0"
}
variable "db_subnet_group_name" {
  description = "The name of the DB subnet group to associate with the RDS instance"
  type        = string
  default     = "default"
}
variable "environment" {
  description = "The environment for which the RDS instance is being created (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}
variable "region" {
  description = "The AWS region where the RDS instance will be created"
  type        = string
  default     = "ap-south-1"
}

#use the commented variables below if you need to customize further

/*variable "db_security_group_ids" {
  description = "A list of security group IDs to associate with the RDS instance"
  type        = list(string)
  default     = []
}
variable "db_multi_az" {
  description = "Whether to create a Multi-AZ RDS instance"
  type        = bool
  default     = false
}
variable "db_backup_retention_period" {
  description = "The number of days to retain backups for the RDS instance"
  type        = number
  default     = 7
}
variable "db_deletion_protection" {
  description = "Whether to enable deletion protection for the RDS instance"
  type        = bool
  default     = false
}
variable "db_port" {
  description = "The port on which the database accepts connections"
  type        = number
  default     = 3306
}
variable "db_storage_encrypted" {
  description = "Whether to enable storage encryption for the RDS instance"
  type        = bool
  default     = false
}
variable "db_kms_key_id" {
  description = "The KMS key ID for storage encryption"
  type        = string
  default     = ""
}*/
