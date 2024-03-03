# RDSインスタンスを作成
module "rds" {
  source             = "../../modules/rds"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.subnet_ids
  subnet_group_name  = "foo-dev-subnet-group"
  security_group_ids = [module.rds_sg.sg_id]

  multi_az            = false
  publicly_accessible = false
  skip_final_snapshot = true
  tags = {
    Name = "foo-dev-rds"
  }
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.micro"
  # 後で変更するために、初期値を設定
  db_username = "uninitializeuser"
  # 後で変更するために、初期値を設定
  db_password          = "uninitializepassword"
  parameter_group_name = "default.mysql8.0"
}
