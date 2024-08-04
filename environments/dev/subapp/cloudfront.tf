output "cloudfront_domain" {
  value = module.cloudfront_web.domain
}

# CloudFrontを作成
module "cloudfront_web" {
  source     = "../../../modules/cloudfront"
  cors       = false
  create_oac = true
  oac_name   = "foo-subapp-dev-oac"

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
      path_pattern           = "/images/*"
      origin_id              = data.terraform_remote_state.common.outputs.s3_images_bucket_name
      allowed_methods        = ["GET", "HEAD"]
      cached_methods         = ["GET", "HEAD"]
      headers                = []
      query_string           = false
      cookies_forward        = "none"
      viewer_protocol_policy = "allow-all"
    }
  ]

  # function_associations = [
  #   {
  #     event_type   = "viewer-request"
  #     function_arn = data.terraform_remote_state.common.outputs.cf_functions_basic_auth_arn
  #   },
  #   {
  #     event_type   = "viewer-request"
  #     # function_arn = data.terraform_remote_state.common.outputs.cf_functions_ip_restriction_arn
  #   }
  # ]
}

data "aws_s3_bucket_policy" "current_policy" {
  bucket = data.terraform_remote_state.common.outputs.s3_images_bucket_name
}

module "s3_bucket_policy" {
  source      = "../../../modules/s3_bucket_policy"
  bucket_name = data.terraform_remote_state.common.outputs.s3_images_bucket_name
  bucket_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      jsondecode(data.aws_s3_bucket_policy.current_policy.policy).Statement[0],
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
