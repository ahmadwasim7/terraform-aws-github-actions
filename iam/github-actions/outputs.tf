output "role_arn" {
  value = aws_iam_role.github_actions_oidc.arn
}

output "oidc_provider_arn" {
  description = "GitHub OIDC provider ARN"
  value       = aws_iam_openid_connect_provider.github.arn
}