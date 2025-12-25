resource "aws_iam_policy" "terraform_ci_infra_policy" {
  name        = "TerraformCI-InfrastructurePolicy"
  description = "Permissions for Terraform CI/CD to manage AWS infrastructure and remote state"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = [
          "ec2:*",
          "vpc:*",
          "iam:PassRole",
          "s3:*",
          "dynamodb:*"
        ]
        Resource = "*"
      }
    ]
  })
}
