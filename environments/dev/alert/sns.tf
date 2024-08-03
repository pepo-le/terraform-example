module "sns" {
  source   = "../../../modules/sns"
  name     = "foo-app-dev-sns-topic"
  protocol = "email"
  endpoint = var.sns_email
}
