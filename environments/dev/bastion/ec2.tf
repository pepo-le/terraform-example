output "ec2_private_ip" {
  value = module.ec2_instance.private_ip
}

output "ec2_public_ip" {
  value = module.ec2_instance.public_ip
}

output "ec2_eip" {
  value = module.ec2_instance.eip
}

data "aws_ssm_parameter" "amazonlinux_2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2" # x86_64
}

module "ec2_instance" {
  source                      = "../../../modules/ec2"
  tags_name                   = "foo-bastion-dev-ec2"
  instance_type               = "t2.micro"
  ami                         = data.aws_ssm_parameter.amazonlinux_2.value
  subnet_id                   = data.terraform_remote_state.common.outputs.public_subnet_ids[0]
  security_group_ids          = [module.bastion_sg.id]
  associate_public_ip_address = false
  key_name                    = "foo-key"
  associate_eip               = true
}
