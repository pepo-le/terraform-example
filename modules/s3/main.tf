resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_allow" {
  count  = var.is_public ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  count  = var.is_public ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Action    = ["s3:GetObject"]
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.bucket.arn}/*"
        Principal = "*"
      },
    ]
  })

  depends_on = [aws_s3_bucket.bucket, aws_s3_bucket_public_access_block.bucket_public_access_allow]
}
