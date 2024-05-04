resource "aws_instance" "main" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address

  security_groups = var.security_group_ids
  key_name        = var.key_name

  tags = {
    Name = var.tags_name
  }
}

resource "aws_eip" "main" {
  count  = var.associate_eip ? 1 : 0
  domain = "vpc"
}

resource "aws_eip_association" "main" {
  count         = var.associate_eip ? 1 : 0
  instance_id   = aws_instance.main.id
  allocation_id = aws_eip.main[0].id
}
