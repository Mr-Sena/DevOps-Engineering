# Doc AWS Provider: [ https://registry.terraform.io/providers/hashicorp/aws/latest/docs ]
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.34.0"
    }
  }
}

provider "aws" {
  region = var.region_area
}
