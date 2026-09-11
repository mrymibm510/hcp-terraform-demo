terraform {
  cloud {
    organization = "maryams-sandbox"

    workspaces {
      name = "hcp-terraform-demo"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.42.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}



resource "aws_s3_bucket" "hercBucket" {
  bucket = "mxsbucket786"

  tags = {
    Name        = "MyDemoBucket"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket" "rentalBucket" {
  bucket = "hercbucket21"

  tags = {
    Name        = "MyDemoBucket2"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
