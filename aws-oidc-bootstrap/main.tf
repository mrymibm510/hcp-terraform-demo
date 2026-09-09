terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.42.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Fetches HCP Terraform's TLS certificate so the OIDC provider's thumbprint
# stays correct even if HCP Terraform rotates its certificate.
data "tls_certificate" "tfc_certificate" {
  url = "https://${var.tfc_hostname}"
}

resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = "https://${var.tfc_hostname}"
  client_id_list  = [var.tfc_aws_audience]
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
}

data "aws_iam_policy_document" "tfc_trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.tfc_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.tfc_hostname}:aud"
      values   = [var.tfc_aws_audience]
    }

    # StringLike + run_phase:* lets both plan and apply runs assume this
    # single role. Split into two roles/policies if plan and apply need
    # different permissions.
    condition {
      test     = "StringLike"
      variable = "${var.tfc_hostname}:sub"
      values   = ["organization:${var.tfc_organization}:project:${var.tfc_project}:workspace:${var.tfc_workspace}:run_phase:*"]
    }
  }
}

resource "aws_iam_role" "tfc_role" {
  name               = var.tfc_role_name
  assume_role_policy = data.aws_iam_policy_document.tfc_trust_policy.json
}

data "aws_iam_policy_document" "tfc_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketTagging",
      "s3:PutBucketTagging",
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:PutBucketAcl",
      "s3:GetBucketAcl",
    ]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/*"]
  }
}

resource "aws_iam_role_policy" "tfc_permissions" {
  name   = "${var.tfc_role_name}-s3-permissions"
  role   = aws_iam_role.tfc_role.id
  policy = data.aws_iam_policy_document.tfc_permissions.json
}
