# Data for Fetching Latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS Account ID (owner of Ubuntu AMIs)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-*-x86_64-gp2"]
  }
}

####################################   edit  ################################
# Fetching VPC ID from SSM Parameter Store 
# Verify the SSM Parameter Exists in AWS SSM using the AWS CLI command below
# aws ssm get-parameter --name "/your/parameter/subnet_ids"
data "aws_ssm_parameter" "vpc_id" {
  name            = "/accounts/euc1/vpc/vpc_id"
  with_decryption = true
}

# Fetching VPC CIDR from SSM Parameter Store
data "aws_ssm_parameter" "vpc_cidr" {
  name            = "/accounts/euc1/vpc/cidr_block"
  with_decryption = true
}

data "aws_ssm_parameter" "subnets" {
  name = "/accounts/euc1/subnet/ids"  # Replace this with your actual SSM parameter name
  with_decryption = true
}

# Fetching Subnet IDs from SSM Parameter Store
data "aws_ssm_parameter" "subnet_ids" {
  name            = "/accounts/euc1/vpc/subnet_ids"
  with_decryption = true
}

# Fetching TLS certificate ARN from SSM Parameter Store
data "aws_ssm_parameter" "tls_cert" {
  name            = "/accounts/global/acm/certificate/tls_cert_arn"
  with_decryption = true
}

# Fetching route53 zone IDs from SSM Parameter Store
data "aws_ssm_parameter" "zone_id" {
  name            = "/accounts/euc1/route53/zone/id"
  with_decryption = true
}

# Fetching account ID from SSM Parameter Store
data "aws_ssm_parameter" "account_id" {
  name            = "/accounts/aws/id"
  with_decryption = true
}
####################################   edit  ################################