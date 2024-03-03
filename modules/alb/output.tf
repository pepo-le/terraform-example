output "target_group_arn" {
  value       = aws_lb_target_group.tg.arn
  description = "ターゲットグループのARN"
}

output "name" {
  value       = aws_lb.lb.name
  description = "ALBの名前"
}

output "dns_name" {
  value       = aws_lb.lb.dns_name
  description = "ALBのDNS名"
}
