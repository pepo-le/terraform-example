# ALBを作成
module "alb" {
  source                     = "../../modules/alb"
  name                       = "foo-dev-alb"
  internal                   = false
  sg_id                      = module.http_sg.sg_id
  subnet_ids                 = module.vpc.subnet_ids
  enable_deletion_protection = false
  listener_port              = 80
  tg_name                    = "foo-dev-alb-tg"
  tg_port                    = 3000
  tg_vpc_id                  = module.vpc.vpc_id
  tg_target_type             = "ip"
}
