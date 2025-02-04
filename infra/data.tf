# Data for Fetching Latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID
  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
    }
  filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }
}

################# Fetching Data from SSM Parameter Store ####################

# Verify the SSM Parameter Exists in AWS SSM using the AWS CLI command below
# aws ssm get-parameter --name "/your/parameter/subnet_ids" eg: "/MyEcommApp/euc1/vpc/vpc_id"

# Run this AWS CLI command to store the VPC ID: 
# Without description: aws ssm put-parameter --name "/E-comApp/vpc/vpc_id" --value "vpc-0528dc4e6cbc1eb6c" --type "String"
# Or with description: aws ssm put-parameter --name "/MyEcommApp/euc1/vpc/cidr_cidr" --value "172.x.x.x/y" --type "String" --overwrite --description "CIDR block for MyEcommApp VPC in eu-central-1"

data "aws_ssm_parameter" "vpc_id" {
  name            = "/MyEcommApp/euc1/vpc/vpc_id"
  with_decryption = true
}

# Fetching VPC CIDR from SSM Parameter Store
data "aws_ssm_parameter" "vpc_cidr" {
  name            = "/MyEcommApp/euc1/vpc/cidr_block"
  with_decryption = true
}

data "aws_ssm_parameter" "subnets" {
  name            = "/MyEcommApp/euc1/subnet/ids" # Replace this with your actual SSM parameter name
  with_decryption = true
}

# Fetching Subnet IDs from SSM Parameter Store
# data "aws_ssm_parameter" "subnet_ids" {
#   name            = "/MyEcommApp/euc1/vpc/subnet_ids"
#   with_decryption = true
# }

# Fetching TLS certificate ARN from SSM Parameter Store
# data "aws_ssm_parameter" "tls_cert" {
#   name            = "/MyEcommApp/global/acm/certificate/tls_cert_arn"
#   with_decryption = true
# }

# Fetching route53 zone IDs from SSM Parameter Store
data "aws_ssm_parameter" "zone_id" {
  name            = "/MyEcommApp/euc1/route53/zone/id"
  with_decryption = true
}

# Fetching account ID from SSM Parameter Store
data "aws_ssm_parameter" "account_id" {
  name            = "/global/aws/id"
  with_decryption = true
}

data "aws_ssm_parameter" "bucket_name" {
  name            = "/terraform/backend/bucket"
  with_decryption = true
}

data "aws_ssm_parameter" "ssl_cert_arn" {
  name            = "/MyEcommApp/ssl/ssl_cert_arn"
  with_decryption = true
}