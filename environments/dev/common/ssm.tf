output "ssm_db_user" {
  value = module.ssm_db_user.parameter_arn
}

output "ssm_db_password" {
  value = module.ssm_db_password.parameter_arn
}

output "ssm_db_hostname" {
  value = module.ssm_db_hostname.parameter_arn
}

# パラメータストアのパラメータを作成
module "ssm_db_user" {
  source                = "../../../modules/ssm"
  parameter_name        = "foo-dev-db-user"
  parameter_type        = "String"
  parameter_description = "foo dev db user"
  parameter_value       = "foouser"
}

module "ssm_db_password" {
  source                = "../../../modules/ssm"
  parameter_name        = "foo-dev-db-password"
  parameter_type        = "SecureString"
  parameter_description = "foo dev db password"
  # 後で変更するために、初期値を設定
  parameter_value = "uninitializepassword"
}

module "ssm_db_hostname" {
  source                = "../../../modules/ssm"
  parameter_name        = "foo-dev-db-name"
  parameter_type        = "String"
  parameter_description = "foo dev db name"
  parameter_value       = module.rds.hostname
}
