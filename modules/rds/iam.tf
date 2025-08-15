/*resource "aws_iam_role" "rds_secrets_role" {
  name = "airnz-rds-secrets-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "rds.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_policy" "secrets_access" {
  name        = "airnz-secrets-access"
  description = "Access to RDS credentials secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "secretsmanager:GetSecretValue"
      Effect   = "Allow"
      Resource = aws_secretsmanager_secret.rds_secret.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_secrets" {
  role       = aws_iam_role.rds_secrets_role.name
  policy_arn = aws_iam_policy.secrets_access.arn
}*/
#Use the above IAM role and policy if you need to access RDS credentials from Secrets Manager

#use the following data source to get the current AWS account ID
data "aws_caller_identity" "current" {}

# IAM policy for EC2 to connect to RDS using IAM authentication
resource "aws_iam_policy" "rds_connect_master" {
  name   = "AllowEC2RDSConnectMaster"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "rds-db:connect"
        Resource = [ "arn:aws:rds-db:${var.region}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_db_instance.myrds.id}/${aws_db_instance.myrds.username}",
                "arn:aws:rds-db:${var.region}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_db_instance.myrds.id}/iam_user"
                #Use the above line if you want to connect using an IAM user and * in place of "iam_user" to allow all users
        ]
                }
    ]
  })
}

# Attach the policy to the EC2 role
resource "aws_iam_role_policy_attachment" "attach_rds_connect" {
  role       = data.terraform_remote_state.ec2.outputs.ec2_role_name
  policy_arn = aws_iam_policy.rds_connect_master.arn
}
