module "route53_health_check" {
  source            = "../../../modules/route53_health_check"
  disabled          = false
  fqdn              = data.terraform_remote_state.app.outputs.cloudfront_domain
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
  measure_latency   = true
  name              = "foo-app-dev-health-check"

  alarm_name                = "foo-app-dev-route53-healthCheck-alarm"
  comparison_operator       = "LessThanThreshold"
  metric_name               = "HealthCheckStatus"
  evaluation_periods        = 1
  period                    = 60
  statistic                 = "Minimum"
  threshold                 = 1
  alarm_description         = "This alarm monitors the status of the Route 53 health check."
  alarm_actions             = [module.sns.arn]
  ok_actions                = [module.sns.arn]
  insufficient_data_actions = [module.sns.arn]
}
