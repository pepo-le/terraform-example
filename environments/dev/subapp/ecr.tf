# ECRリポジトリを作成
module "ecr" {
  source          = "../../../modules/ecr"
  repository_name = "foo-subapp-dev-repository"
}
