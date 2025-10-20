# This file contains the configuration for managing RDS passwords using AWS Secrets Manager and random password generation.
resource "random_password" "rds_master_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret_version" "rds_password_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = random_password.rds_master_password.result
}
