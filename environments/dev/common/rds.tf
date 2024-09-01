output "rds_hostname" {
  value = module.rds.hostname
}

# RDSインスタンスを作成
module "rds" {
  source             = "../../../modules/rds"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  subnet_group_name  = "foo-dev-subnet-group"
  security_group_ids = [module.rds_sg.id]

  multi_az            = false
  publicly_accessible = false
  skip_final_snapshot = true

  backup_retention_period = 7
  backup_window           = "18:30-19:00"

  tags = {
    Name = "foo-dev-rds"
  }
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.micro"
  db_username       = "foouser"
  # 後で変更するために、初期値を設定
  db_password = "uninitializepassword"

  parameter_group_name   = "foo-dev-parameter-group"
  parameter_group_family = "mysql8.0"
  parameter_group_parameters = {
    time_zone = "Asia/Tokyo"
  }
}
