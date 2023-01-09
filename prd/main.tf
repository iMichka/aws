terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "eu-west-3"

  default_tags {
    tags = {
      Env = var.tag_prd
    }
  }
}
