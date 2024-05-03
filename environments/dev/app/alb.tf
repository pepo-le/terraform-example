# ALBを作成
module "alb" {
  source                     = "../../../modules/alb"
  name                       = "foo-app-dev-alb"
  internal                   = false
  sg_id                      = module.alb_sg.id
  subnet_ids                 = data.terraform_remote_state.common.outputs.subnet_ids
  enable_deletion_protection = false
  listener_port              = 80
  tg_name                    = "foo-app-dev-alb-tg"
  tg_port                    = 3000
  tg_vpc_id                  = data.terraform_remote_state.common.outputs.vpc_id
  tg_health_check_path       = "/"
  tg_target_type             = "ip"
}
