# セキュリティグループを作成
module "http_sg" {
  source  = "../../modules/security_group"
  sg_name = "foo-dev-http-sg"
  vpc_id  = module.vpc.vpc_id

  rule_map = {
    http_1 = {
      type                     = "ingress"
      from_port                = 80
      to_port                  = 80
      protocol                 = "TCP"
      cidr_blocks              = ["0.0.0.0/0"]
      ipv6_cidr_blocks         = null
      source_security_group_id = null
      description              = "allow http"
    }
    http_2 = {
      type                     = "ingress"
      from_port                = 443
      to_port                  = 443
      protocol                 = "TCP"
      cidr_blocks              = ["0.0.0.0/0"]
      ipv6_cidr_blocks         = null
      source_security_group_id = null
      description              = "allow http"
    }
    http_3 = {
      type                     = "egress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "TCP"
      cidr_blocks              = ["0.0.0.0/0"]
      ipv6_cidr_blocks         = null
      source_security_group_id = null
      description              = "allow http"
    }
  }
}

module "ecs_sg" {
  source  = "../../modules/security_group"
  sg_name = "foo-dev-ecs-sg"
  vpc_id  = module.vpc.vpc_id

  rule_map = {
    ecs_1 = {
      type                     = "ingress"
      from_port                = 3000
      to_port                  = 3000
      protocol                 = "TCP"
      cidr_blocks              = null
      ipv6_cidr_blocks         = null
      source_security_group_id = module.http_sg.sg_id
      description              = "allow http"
    }
    ecs_2 = {
      type                     = "egress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "TCP"
      cidr_blocks              = ["0.0.0.0/0"]
      ipv6_cidr_blocks         = null
      source_security_group_id = null
      description              = "allow http"
    }
  }
}

module "rds_sg" {
  source  = "../../modules/security_group"
  sg_name = "foo-dev-rds-sg"
  vpc_id  = module.vpc.vpc_id

  rule_map = {
    rds_1 = {
      type                     = "ingress"
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "TCP"
      cidr_blocks              = null
      ipv6_cidr_blocks         = null
      source_security_group_id = module.http_sg.sg_id
      description              = "allow mysql"
    },
    rds_2 = {
      type                     = "egress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "TCP"
      cidr_blocks              = null
      ipv6_cidr_blocks         = null
      source_security_group_id = module.http_sg.sg_id
      description              = "allow mysql"
    },
  }
}
