output "cloudfront_domain" {
  value = module.cloudfront_web.domain
}

# CloudFrontを作成
module "cloudfront_web" {
  source     = "../../../modules/cloudfront"
  cors       = false
  create_oac = true
  oac_name   = "foo-app-dev-oac"

  use_cache_and_origin_request_policy = false
  default_cache_behavior = {
    target_origin_id = data.terraform_remote_state.common.outputs.alb_name
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values = {
      headers      = ["*"]
      query_string = true
      cookies = {
        forward = "all"
      }
    }

    viewer_protocol_policy = "allow-all"
  }

  origins = [
    {
      origin_id   = data.terraform_remote_state.common.outputs.alb_name
      domain_name = data.terraform_remote_state.common.outputs.alb_dns_name
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
      use_oac = false
    },
    {
      origin_id            = data.terraform_remote_state.common.outputs.s3_images_bucket_name
      domain_name          = data.terraform_remote_state.common.outputs.s3_images_bucket_domain_name
      custom_origin_config = null
      use_oac              = true
    }
  ]

  ordered_cache_behaviors = [
    {
      path_pattern    = "/images/*"
      origin_id       = data.terraform_remote_state.common.outputs.s3_images_bucket_name
      allowed_methods = ["GET", "HEAD"]
      cached_methods  = ["GET", "HEAD"]

      use_cache_and_origin_request_policy = false
      forwarded_values = {
        headers      = []
        query_string = false
        cookies = {
          forward = "none"
        }
      }
      function_associations  = []
      viewer_protocol_policy = "allow-all"
    }
  ]
}

module "s3_bucket_policy" {
  source      = "../../../modules/s3_bucket_policy"
  bucket_name = data.terraform_remote_state.common.outputs.s3_images_bucket_name
  bucket_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${data.terraform_remote_state.common.outputs.s3_images_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = module.cloudfront_web.arn
          }
        }
      }
    ]
  })
}
