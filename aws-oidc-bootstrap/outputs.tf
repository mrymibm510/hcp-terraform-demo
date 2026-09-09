output "tfc_run_role_arn" {
  description = "Set this as TFC_AWS_RUN_ROLE_ARN in the BTS-demo-CLI HCP Terraform workspace."
  value       = aws_iam_role.tfc_role.arn
}

output "tfc_provider_arn" {
  description = "ARN of the AWS OIDC identity provider created for HCP Terraform."
  value       = aws_iam_openid_connect_provider.tfc_provider.arn
}
