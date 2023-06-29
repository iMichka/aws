terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5.0"
    }
  }

  required_version = ">= 1.5.2"
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Env = var.tag_prd
    }
  }
}
