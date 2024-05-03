terraform {
  required_version = ">=  0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "tfstate-terraform-foo-12345"
    region = "us-east-1"
    key    = "foo-app/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}
