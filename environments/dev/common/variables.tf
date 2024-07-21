output "allow_ip_address" {
  value = var.allow_ip_address
}

output "allow_ipv6_address" {
  value = var.allow_ipv6_address
}

variable "allow_ip_address" {
  description = "接続を許可するIPアドレス"
  type        = string
}

variable "allow_ipv6_address" {
  description = "接続を許可するIPv6アドレス"
  type        = string
}

variable "aws_source_profile" {
  description = "AWS CLIのスイッチ元プロファイル名"
  type        = string
}

variable "aws_role_arn" {
  description = "AWSのロールARN"
  type        = string
}
