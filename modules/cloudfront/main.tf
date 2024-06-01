resource "aws_cloudfront_origin_access_identity" "main" {
  comment = var.oai_comment
}

resource "aws_cloudfront_distribution" "main" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = var.comment

  default_cache_behavior {
    target_origin_id = var.default_cache_behavior.target_origin_id
    allowed_methods  = var.default_cache_behavior.allowed_methods
    cached_methods   = var.default_cache_behavior.cached_methods

    forwarded_values {
      headers      = var.default_cache_behavior.forwarded_values.headers
      query_string = var.default_cache_behavior.forwarded_values.query_string

      cookies {
        forward = var.default_cache_behavior.forwarded_values.cookies.forward
      }
    }

    viewer_protocol_policy = var.default_cache_behavior.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = 3600
    max_ttl                = 86400

    dynamic "function_association" {
      for_each = var.function_associations

      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }
  }

  dynamic "origin" {
    for_each = var.origins

    content {
      origin_id   = origin.value.origin_id
      domain_name = origin.value.domain_name

      dynamic "custom_origin_config" {
        for_each = origin.value.custom_origin_config != null ? [origin.value.custom_origin_config] : []
        content {
          http_port              = custom_origin_config.value.http_port
          https_port             = custom_origin_config.value.https_port
          origin_protocol_policy = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols   = custom_origin_config.value.origin_ssl_protocols
        }
      }

      dynamic "s3_origin_config" {
        for_each = origin.value.custom_origin_config == null ? [1] : []
        content {
          origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
        }
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors

    content {
      path_pattern     = ordered_cache_behavior.value.path_pattern
      target_origin_id = ordered_cache_behavior.value.origin_id
      allowed_methods  = ordered_cache_behavior.value.allowed_methods
      cached_methods   = ordered_cache_behavior.value.cached_methods

      forwarded_values {
        headers      = ordered_cache_behavior.value.headers
        query_string = ordered_cache_behavior.value.query_string
        cookies {
          forward = ordered_cache_behavior.value.cookies_forward
        }
      }
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      min_ttl                = 0
      default_ttl            = 3600
      max_ttl                = 86400
    }
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
