# セキュリティグループを作成
module "bastion_sg" {
  source  = "../../../modules/security_group"
  sg_name = "foo-bastion-dev-ec2-sg"
  vpc_id  = data.terraform_remote_state.common.outputs.vpc_id
}

module "sgr_bastion_ingress" {
  source                   = "../../../modules/security_group_rule"
  security_group_id        = module.bastion_sg.id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "TCP"
  cidr_blocks              = ["${data.terraform_remote_state.common.outputs.allow_ip_address}/32"]
  ipv6_cidr_blocks         = null
  source_security_group_id = null
  prefix_list_ids          = []
}

module "sgr_bastion_egress" {
  source                   = "../../../modules/security_group_rule"
  security_group_id        = module.bastion_sg.id
  type                     = "egress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "TCP"
  cidr_blocks              = ["0.0.0.0/0"]
  ipv6_cidr_blocks         = null
  source_security_group_id = null
  prefix_list_ids          = []
}
