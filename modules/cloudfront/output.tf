output "oai_iam_arn" {
  value       = aws_cloudfront_origin_access_identity.main.iam_arn
  description = "CloudFrontのIAM ARN"
}
