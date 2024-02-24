provider "aws" {
  # プロファイル名を指定
  profile = "terraform"
  region  = "us-east-1"
}

terraform {
  required_version = ">=  0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "tfstate-terraform"
    region = "us-east-1"
    key    = "foo/terraform.tfstate"
  }
}
