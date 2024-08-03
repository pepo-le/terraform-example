variable "aws_source_profile" {
  description = "AWS CLIのスイッチ元プロファイル名"
  type        = string
}

variable "aws_role_arn" {
  description = "AWSのロールARN"
  type        = string
}

variable "sns_email" {
  description = "SNSのエンドポイント（メールアドレス）"
  type        = string
}
