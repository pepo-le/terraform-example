variable "comment" {
  description = "CloudFrontのコメント"
  type        = string
  default     = ""
}

variable "default_cache_behavior" {
  description = "CloudFrontのデフォルトキャッシュ動作"
  type = object({
    target_origin_id = string
    allowed_methods  = list(string)
    cached_methods   = list(string)
    forwarded_values = object({
      headers      = list(string)
      query_string = bool
      cookies = object({
        forward = string
      })
    })
    viewer_protocol_policy = string
  })
}

variable "min_ttl" {
  description = "最小TTL"
  type        = number
  default     = 0
}

variable "origins" {
  description = "CloudFrontのオリジンのリスト"
  type = list(object({
    origin_id   = string
    domain_name = string
    custom_origin_config = object({
      http_port              = number
      https_port             = number
      origin_protocol_policy = string
      origin_ssl_protocols   = list(string)
    })
  }))
}

variable "ordered_cache_behaviors" {
  description = "キャッシュ動作のリスト"
  type = list(object({
    path_pattern           = string
    origin_id              = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    headers                = list(string)
    query_string           = bool
    cookies_forward        = string
    viewer_protocol_policy = string
  }))
}

variable "origin_access_control" {
  description = "CloudFrontのオリジンアクセスコントロール"
  type        = string
  default     = ""
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

variable "oai_comment" {
  description = "CloudFrontのOAIのコメント"
  type        = string
  default     = ""
}

variable "basic_auth" {
  description = "Basic認証を有効にするかどうか"
  type        = bool
  default     = false
}

variable "function_associations" {
  description = "CloudFront Functionsの関連付け"
  type = list(object({
    event_type   = string
    function_arn = string
  }))
  default = []
}
