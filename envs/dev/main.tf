terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_name              = var.vpc_name
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  availability_zones    = var.availability_zones
}

module "ec2" {
  source = "../../modules/ec2"

  name               = var.ec2_name
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_ids[0]
  vpc_id             = module.vpc.vpc_id
  key_name           = var.key_name
  ssh_allowed_cidrs  = var.ssh_allowed_cidrs
}
