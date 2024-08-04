# ECRリポジトリを作成
module "ecr" {
  source            = "../../../modules/ecr"
  create_repository = true
  repository_name   = "foo-app-dev-repository"
}
