variable "alb_name" {
  description = "ALBの名前"
  type        = string
}

variable "internal" {
  description = "内部ALBかどうか"
  type        = bool
  default     = false
}

variable "alb_sg_id" {
  description = "ALBに関連付けるセキュリティグループのID"
  type        = string
}

variable "alb_subnet_ids" {
  description = "ALBを配置するサブネットのIDのリスト"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "削除保護を有効にするかどうか"
  type        = bool
  default     = false
}

variable "alb_tg_name" {
  description = "ターゲットグループの名前"
  type        = string
}

variable "alb_port" {
  description = "ターゲットグループのポート"
  type        = number
}

variable "alb_tg_vpc_id" {
  description = "ターゲットグループを作成するVPCのID"
  type        = string
}
