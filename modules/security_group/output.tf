output "sg_id" {
  value       = aws_security_group.sg.id
  description = "セキュリティグループのID"
}

output "sg_name" {
  value       = aws_security_group.sg.name
  description = "セキュリティグループ名"
}
