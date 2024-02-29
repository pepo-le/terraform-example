output "bucket_name" {
  value       = aws_s3_bucket.bucket.id
  description = "S3バケット名"
}

output "bucket_arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "S3バケットのARN"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.bucket.bucket_domain_name
  description = "S3バケットのドメイン名"
}
