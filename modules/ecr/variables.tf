variable "repository_name" {
  description = "ECRリポジトリの名前"
  type        = string
}

variable "image_tag_mutability" {
  description = "ECRリポジトリのイメージタグの変更可能性"
  type        = string
  default     = "MUTABLE"
}
