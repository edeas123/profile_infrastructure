terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.24.1"
    }
  }

  backend "s3" {
    bucket         = "mybytesni-terraform-state"
    key            = "profile-infrastructure"
    region         = "us-east-1"
    dynamodb_table = "mybytesni-terraform-state"
    profile        = "mybytesni"
    encrypt        = true
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "mybytesni"
}
