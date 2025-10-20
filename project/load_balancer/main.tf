############################################################
# Data sources (defaults if variables empty)
############################################################
data "aws_vpc" "selected" {
  count   = length(var.vpc_id) > 0 ? 0 : 1
  default = true
}

locals {
  vpc_id      = length(var.vpc_id) > 0 ? var.vpc_id : data.aws_vpc.selected[0].id
  asg_subnets = length(var.asg_subnets) > 0 ? var.asg_subnets : var.alb_subnets
}

# ✅ Corrected AMI data source
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

############################################################
# Security groups
############################################################
resource "aws_security_group" "alb_sg" {
  name        = "${var.alb_name}-alb-sg"
  description = "ALB security group"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = var.to_port
    to_port     = var.to_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "${var.alb_name}-inst-sg"
  description = "Instance SG: allow HTTP from ALB and SSH from admin CIDR"
  vpc_id      = local.vpc_id

  ingress {
    from_port       = var.to_port
    to_port         = var.to_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "Allow HTTP from ALB"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
    description = "SSH from admin"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################################
# ALB
############################################################
resource "aws_lb" "alb" {
  name                       = var.alb_name
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = var.alb_subnets
  security_groups            = [aws_security_group.alb_sg.id]
  enable_deletion_protection = false  #Set to true in production

  tags = {
    Name = var.alb_name
    Env  = "production"
  }
}

############################################################
# Default (homepage) target group
############################################################
resource "aws_lb_target_group" "default_tg" {
  name        = "${var.alb_name}-tg-homepage"
  port        = var.to_port
  protocol    = var.conn_protocol
  target_type = var.target_type
  vpc_id      = local.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

############################################################
# Path-based Target Groups (one per context_path)
############################################################
resource "aws_lb_target_group" "tg" {
  for_each   = var.context_paths
  depends_on = [aws_lb.alb]

  name        = "${var.alb_name}-tg-${each.key}"
  port        = var.to_port
  protocol    = var.conn_protocol
  target_type = var.target_type
  vpc_id      = local.vpc_id

  health_check {
    path                = each.value
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "tg-${each.key}"
  }
}

############################################################
# Listener + default + path rules
############################################################
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.to_port
  protocol          = var.conn_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default_tg.arn
  }
}

resource "aws_lb_listener_rule" "path_based" {
  for_each     = var.context_paths
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 10 + index(keys(var.context_paths), each.key)

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[each.key].arn
  }

  condition {
    path_pattern {
      values = [each.value]
    }
  }
}

############################################################
# IAM role & instance profile for instances
############################################################
resource "aws_iam_role" "instance_role" {
  name = "${var.alb_name}-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cw" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.alb_name}-instance-profile"
  role = aws_iam_role.instance_role.name
}

############################################################
# Launch Template(s)
############################################################
resource "aws_launch_template" "generic" {
  name_prefix   = "${var.alb_name}-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  network_interfaces {
    security_groups             = [aws_security_group.instance_sg.id]
    associate_public_ip_address = true
  }

  user_data = base64encode(var.user_data_install)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.alb_name}-lt"
    }
  }
}

############################################################
# Homepage ASG
############################################################
resource "aws_autoscaling_group" "homepage_asg" {
  name                      = "${var.alb_name}-homepage-asg"
  min_size                  = var.homepage_asg.min_size
  desired_capacity          = var.homepage_asg.desired_capacity
  max_size                  = var.homepage_asg.max_size
  health_check_type         = "ELB"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.generic.id
    version = "$Latest"
  }

  vpc_zone_identifier = local.asg_subnets
  target_group_arns   = [aws_lb_target_group.default_tg.arn]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_lb.alb]
}

resource "aws_autoscaling_policy" "homepage_target_tracking" {
  name                   = "${var.alb_name}-homepage-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.homepage_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.homepage_asg.cpu_target_value
  }
}

############################################################
# Autoscaling Group per path-based TG
############################################################
resource "aws_launch_template" "per_tg_lt" {
  for_each = aws_lb_target_group.tg

  name_prefix   = "${var.alb_name}-${each.key}-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  network_interfaces {
    security_groups             = [aws_security_group.instance_sg.id]
    associate_public_ip_address = true
  }

  user_data = base64encode(var.user_data_install)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.alb_name}-${each.key}"
      TG   = each.key
    }
  }
}

resource "aws_autoscaling_group" "per_tg_asg" {
  for_each = var.context_paths
  name     = "${var.alb_name}-${each.key}-asg"
  
  # Use a lookup to get specific config, or fall back to defaults
  min_size         = lookup(var.per_tg_asg_config, each.key, var.per_tg_asg_defaults).min_size
  desired_capacity = lookup(var.per_tg_asg_config, each.key, var.per_tg_asg_defaults).desired_capacity
  max_size         = lookup(var.per_tg_asg_config, each.key, var.per_tg_asg_defaults).max_size
  health_check_type         = "ELB"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.per_tg_lt[each.key].id
    version = "$Latest"
  }

  vpc_zone_identifier = local.asg_subnets
  target_group_arns   = [aws_lb_target_group.tg[each.key].arn]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_lb.alb]
}

resource "aws_autoscaling_policy" "per_tg_target_tracking" {
  for_each               = var.context_paths
  name                   = "${var.alb_name}-${each.key}-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.per_tg_asg[each.key].name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    # Use a lookup to get the specific CPU target value
    target_value = lookup(var.per_tg_asg_config, each.key, var.per_tg_asg_defaults).cpu_target_value
  }
}

############################################################
# Optional: Static Instances (manual mapping)
############################################################
resource "aws_instance" "static_named" {
  for_each = var.instance_mapping

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = length(local.asg_subnets) > 0 ? local.asg_subnets[0] : var.alb_subnets[0]
  key_name      = var.key_pair_name

  tags = {
    Name       = each.key
    attach_to  = each.value
  }
}

resource "aws_lb_target_group_attachment" "static_attachments" {
  for_each = aws_instance.static_named

  target_group_arn = var.instance_mapping[each.key] == "homepage" ? aws_lb_target_group.default_tg.arn : aws_lb_target_group.tg[var.instance_mapping[each.key]].arn

  target_id = each.value.id
  port      = var.to_port
}