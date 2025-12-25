resource "aws_iam_role" "github_actions_oidc" {
  name = "GitHubActions-OIDC-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud"        = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:repository" = "${var.github_org}/${var.github_repo}"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/${var.github_branch}",
              "repo:${var.github_org}/${var.github_repo}:pull_request*"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ec2_policy" {
  role       = aws_iam_role.github_actions_oidc.name
  policy_arn = aws_iam_policy.terraform_ci_infra_policy.arn
}
