variable "domain_name" {
  description = "オリジンのドメイン名"
  type        = string
}

variable "origin_id" {
  description = "CloudFrontのオリジンID"
  type        = string
}

variable "comment" {
  description = "CloudFrontのコメント"
  type        = string
  default     = ""
}

variable "origin_access_control" {
  description = "CloudFrontのオリジンアクセスコントロール"
  type        = string
  default     = ""
}

variable "origin_type" {
  description = "CloudFrontのオリジンアクセスコントロールのオリジンタイプ"
  type        = string
}

variable "price_class" {
  description = "CloudFrontの価格クラス"
  type        = string
  default     = "PriceClass_200"
}

variable "cors" {
  description = "CORSを有効にするかどうか"
  type        = bool
  default     = true
}
