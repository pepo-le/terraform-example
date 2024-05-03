output "rds_sg_id" {
  value = module.rds_sg.id
}

output "rds_sg_name" {
  value = module.rds_sg.name
}

# セキュリティグループを作成
module "rds_sg" {
  source  = "../../../modules/security_group"
  sg_name = "foo-dev-rds-sg"
  vpc_id  = module.vpc.vpc_id
}

module "sgr_rds_ingress" {
  source                   = "../../../modules/security_group_rule"
  security_group_id        = module.rds_sg.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "TCP"
  cidr_blocks              = ["192.168.0.1/32"]
  ipv6_cidr_blocks         = null
  source_security_group_id = null
  prefix_list_ids          = []
  description              = "allow mysql"
}

module "sgr_rds_egress" {
  source                   = "../../../modules/security_group_rule"
  security_group_id        = module.rds_sg.id
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "TCP"
  cidr_blocks              = ["0.0.0.0/0"]
  ipv6_cidr_blocks         = null
  source_security_group_id = null
  prefix_list_ids          = []
}
