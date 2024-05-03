output "alb_name" {
  value = module.alb.name
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "alb_target_group_arn" {
  value = module.alb.target_group_arn
}

# ALBを作成
module "alb" {
  source                     = "../../../modules/alb"
  name                       = "foo-dev-alb"
  internal                   = false
  sg_id                      = module.alb_sg.id
  subnet_ids                 = module.vpc.subnet_ids
  enable_deletion_protection = false
  listener_port              = 80
  tg_name                    = "foo-dev-alb-tg"
  tg_port                    = 3000
  tg_vpc_id                  = module.vpc.vpc_id
  tg_health_check_path       = "/"
  tg_target_type             = "ip"
}
