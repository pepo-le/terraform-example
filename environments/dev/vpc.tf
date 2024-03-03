# VPCを作成
module "vpc" {
  source             = "../../modules/vpc"
  cidr_block         = "10.10.0.0/16"
  vpc_name           = "foo-dev-vpc"
  subnet_cidr_blocks = ["10.10.0.0/24", "10.10.1.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
}
