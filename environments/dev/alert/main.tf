data "terraform_remote_state" "app" {
  backend = "s3"
  config = {
    region = "us-east-1"
    bucket = "tfstate-terraform-foo-12345"
    key    = "foo-app/terraform.tfstate"

    profile = "terraform"
  }
}
