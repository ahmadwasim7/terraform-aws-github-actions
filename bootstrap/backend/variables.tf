variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket for Terraform remote state"
  type        = string
  default = "my-terraform-ci-state"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table for state locking"
  type        = string
  default = "terraform-locks"
}