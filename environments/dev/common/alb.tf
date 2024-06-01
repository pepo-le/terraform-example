output "alb_name" {
  value = module.alb.name
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "alb_listener_http_arn" {
  value = module.alb.listener_http_arn
}

output "alb_listener_https_arn" {
  value = module.alb.listener_https_arn
}

# ALBを作成
module "alb" {
  source                     = "../../../modules/alb"
  name                       = "foo-dev-alb"
  internal                   = false
  sg_id                      = module.alb_sg.id
  subnet_ids                 = module.vpc.public_subnet_ids
  enable_deletion_protection = false
  listener_port              = 80
  listener_protcol           = "HTTP"
}
