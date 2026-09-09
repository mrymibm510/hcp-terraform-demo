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
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.64.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "tfe" {}


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

data "tfe_github_app_installation" "this" {
  name = "mrymibm510"
}

resource "tfe_policy_set" "sentinel_aws" {
  name         = "sentinel_aws"
  description  = "Sentinel-based policies enforced on AWS resources"
  organization = "maryams-sandbox"
  kind         = "sentinel"
  global       = true

  vcs_repo {
    identifier                 = "mrymibm510/hcp-terraform-demo"
    branch                     = "main"
    ingress_submodules         = false
    github_app_installation_id = data.tfe_github_app_installation.this.id
  }
}