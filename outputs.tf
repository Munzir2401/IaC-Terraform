output "alb_dns" {
  value = aws_lb.alb.dns_name
}

output "homepage_tg_arn" {
  value = aws_lb_target_group.default_tg.arn
}

output "path_tg_arns" {
  value = { for k, tg in aws_lb_target_group.tg : k => tg.arn }
}

output "homepage_asg_name" {
  value = aws_autoscaling_group.homepage_asg.name
}

output "per_tg_asg_names" {
  value = { for k, a in aws_autoscaling_group.per_tg_asg : k => a.name }
}