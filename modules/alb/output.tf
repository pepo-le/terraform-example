output "target_group_arn" {
  value       = aws_lb_target_group.main.arn
  description = "ターゲットグループのARN"
}

output "name" {
  value       = aws_lb.main.name
  description = "ALBの名前"
}

output "dns_name" {
  value       = aws_lb.main.dns_name
  description = "ALBのDNS名"
}
