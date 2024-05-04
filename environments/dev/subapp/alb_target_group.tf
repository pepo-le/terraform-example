# ALBリスナールールを作成
module "alb_target_group" {
  source                    = "../../../modules/alb_target_group"
  tg_name                   = "foo-subapp-dev-alb-tg"
  tg_port                   = 3000
  tg_protocol               = "HTTP"
  tg_vpc_id                 = data.terraform_remote_state.common.outputs.vpc_id
  tg_target_type            = "ip"
  tg_health_check_path      = "/"
  listener_arn              = data.terraform_remote_state.common.outputs.alb_listener_http_arn
  listener_rule_priority    = 200
  listener_rule_action_type = "forward"
  listener_rule_host_header = module.cloudfront_web.domain
}
