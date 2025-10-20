resource "aws_db_instance" "myrds" {
  allocated_storage    = var.db_allocated_storage
  storage_type         = var.db_storage_type
  max_allocated_storage = var.db_max_allocated_storage
  db_name              = var.db_name
  identifier           = var.db_identifier
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  username             = var.db_username
  password             = aws_secretsmanager_secret_version.rds_password_version.secret_string
  iam_database_authentication_enabled = true
  multi_az             = true
  db_subnet_group_name = data.terraform_remote_state.vpc.outputs.database_subnet_group
  parameter_group_name = var.db_parameter_group_name
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.security_group_id]
  /*skip_final_snapshot  = true*/  # Uncomment for production use
}

/*resource "aws_rds_cluster" "myrds_cluster" {
  cluster_identifier = var.db_identifier
  engine             = var.db_engine
  engine_version     = var.db_engine_version
  database_name      = var.db_name
  master_username    = var.db_username
  master_password    = var.db_password
  db_subnet_group_name = data.terraform_remote_state.vpc.outputs.database_subnet_group
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.security_group_id]
  skip_final_snapshot = true

  tags = {
    Name        = "${var.vpc_name}-rds-cluster"
    Environment = var.environment
  }
  
}*/
