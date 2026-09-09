variable "aws_region" {
  description = "AWS region used by the bootstrap AWS provider (IAM/OIDC resources are global)."
  default     = "us-west-2"
}

variable "tfc_hostname" {
  description = "Hostname of the HCP Terraform / Terraform Enterprise instance."
  default     = "app.terraform.io"
}

variable "tfc_aws_audience" {
  description = "Audience value HCP Terraform presents in its identity token."
  default     = "aws.workload.identity"
}

variable "tfc_organization" {
  description = "HCP Terraform organization name."
  default     = "hashicorp-ddr-platform-prod"
}

variable "tfc_project" {
  description = "HCP Terraform project name containing the workspace."
  default     = "ibm-maryam-shahid"
}

variable "tfc_workspace" {
  description = "HCP Terraform workspace name allowed to assume this role."
  default     = "BTS-demo-CLI"
}

variable "tfc_role_name" {
  description = "Name of the IAM role HCP Terraform will assume for dynamic credentials."
  default     = "bts-demo-cli-tfc-dynamic-creds"
}

variable "s3_bucket_name" {
  description = "S3 bucket the role's permissions are scoped to (matches aws_s3_bucket.example in the main config)."
  default     = "mxsbucket987"
}
