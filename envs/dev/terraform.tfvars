aws_region = "us-east-1"

vpc_name = "dev-vpc"
vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

availability_zones = [
  "us-east-1a",
  "us-east-1b"
]

ec2_name       = "dev-ec2"
ami_id         = "ami-068c0051b15cdb816"
instance_type  = "t2.micro"
key_name       = "my_key_pair_usa"

ssh_allowed_cidrs = [
  "117.214.122.149/32"
]
