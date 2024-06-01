output "cloudfront_domain" {
  value = module.cloudfront_web.domain
}

# CloudFrontを作成
module "cloudfront_web" {
  source      = "../../../modules/cloudfront"
  cors        = false
  oai_comment = "foo-subapp-dev-oai"

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
    },
    {
      origin_id            = data.terraform_remote_state.common.outputs.s3_images_bucket_name
      domain_name          = data.terraform_remote_state.common.outputs.s3_images_bucket_domain_name
      custom_origin_config = null
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

  function_associations = [
    {
      event_type   = "viewer-request"
      function_arn = data.terraform_remote_state.common.outputs.cf_functions_basic_auth_arn
    },
    {
      event_type   = "viewer-request"
      function_arn = data.terraform_remote_state.common.outputs.cf_functions_ip_restriction_arn
    }
  ]
}
