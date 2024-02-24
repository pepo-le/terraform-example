variable "cidr_block" {
  description = "VPCのCIDRブロック"
  type        = string
}

variable "vpc_name" {
  description = "VPCの名前"
  type        = string
}

variable "subnet_cidr_blocks" {
  description = "サブネットのCIDRブロックのリスト"
  type        = list(string)
}

variable "availability_zones" {
  description = "使用するアベイラビリティゾーンのリスト"
  type        = list(string)
}
