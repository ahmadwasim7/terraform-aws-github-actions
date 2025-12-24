resource "aws_iam_policy" "ec2_full_access_custom" {
  name        = "EC2FullAccess-2"
  description = "Full EC2 access only"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ec2:*"
        Resource = "*"
      }
    ]
  })
}
