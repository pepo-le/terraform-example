output "own_ip_address" {
  value = var.own_ip_address
}

output "own_ipv6_address" {
  value = var.own_ipv6_address
}

variable "own_ip_address" {
  description = "自身のIPアドレス"
  type        = string
}

variable "own_ipv6_address" {
  description = "自身のIPv6アドレス"
  type        = string
}
