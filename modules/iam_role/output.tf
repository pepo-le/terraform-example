output "name" {
  description = "IAMロールの名前"
  value       = aws_iam_role.role.name
}

output "arn" {
  description = "IAMロールのARN"
  value       = aws_iam_role.role.arn
}
