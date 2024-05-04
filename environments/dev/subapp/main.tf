data "terraform_remote_state" "common" {
  backend = "s3"
  config = {
    region = "us-east-1"
    bucket = "tfstate-terraform-foo-12345"
    key    = "foo-common/terraform.tfstate"
  }
}
