resource "random_id" "rds_id" {
  byte_length = 4
}

resource "aws_secretsmanager_secret" "rds_secret" {
  name        = "${var.environment}-rds-secret-${random_id.rds_id.hex}"
  description = "RDS secret for ${var.environment} environment"
  recovery_window_in_days = 0 # Set to 0 for immediate deletion
}
