# パラメータストアのパラメータを作成
module "ssm_db_user" {
  source                = "../../modules/ssm"
  parameter_name        = "foo-dev-db-user"
  parameter_type        = "String"
  parameter_description = "foo dev db user"
  # 後で変更するために、初期値を設定
  parameter_value = "uninitializeuser"
}

module "ssm_db_password" {
  source                = "../../modules/ssm"
  parameter_name        = "foo-dev-db-password"
  parameter_type        = "SecureString"
  parameter_description = "foo dev db password"
  # 後で変更するために、初期値を設定
  parameter_value = "uninitializepassword"
}
