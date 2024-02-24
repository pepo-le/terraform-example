resource "aws_security_group" "sg" {
  name   = var.sg_name
  vpc_id = var.vpc_id

  tags = {
    Name = var.sg_name
  }
}

resource "aws_security_group_rule" "sg_rule" {
  for_each = var.rule_map

  security_group_id        = aws_security_group.sg.id
  type                     = each.value.type
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.cidr_blocks
  ipv6_cidr_blocks         = each.value.ipv6_cidr_blocks
  source_security_group_id = each.value.source_security_group_id
  description              = each.value.description
}
