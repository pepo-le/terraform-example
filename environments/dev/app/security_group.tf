# セキュリティグループを作成
module "ecs_sg" {
  source  = "../../../modules/security_group"
  sg_name = "foo-app-dev-ecs-sg"
  vpc_id  = data.terraform_remote_state.common.outputs.vpc_id
}

module "sgr_ecs_ingress" {
  source                   = "../../../modules/security_group_rule"
  security_group_id        = module.ecs_sg.id
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "TCP"
  cidr_blocks              = null
  ipv6_cidr_blocks         = null
  source_security_group_id = data.terraform_remote_state.common.outputs.alb_sg_id
  prefix_list_ids          = []
}

module "sgr_ecs_egress" {
  source                   = "../../../modules/security_group_rule"
  security_group_id        = module.ecs_sg.id
  type                     = "egress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "TCP"
  cidr_blocks              = ["0.0.0.0/0"]
  ipv6_cidr_blocks         = null
  source_security_group_id = null
  prefix_list_ids          = []
}

module "sgr_rds_ecs_ingress" {
  source                   = "../../../modules/security_group_rule"
  security_group_id        = data.terraform_remote_state.common.outputs.rds_sg_id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "TCP"
  cidr_blocks              = null
  ipv6_cidr_blocks         = null
  source_security_group_id = module.ecs_sg.id
  prefix_list_ids          = []
}
