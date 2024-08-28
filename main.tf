terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      version = "4.58"
      source  = "hashicorp/aws"
    }
  }

}

provider "aws" {
  region = var.aws_region
}