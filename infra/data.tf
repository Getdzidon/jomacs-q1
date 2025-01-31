# Data for Fetching Latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical's AWS Account ID (owner of Ubuntu AMIs)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-*-x86_64-gp2"]
  }
}

####################################   edit  ################################
# Fetching VPC ID from SSM Parameter Store
data "aws_ssm_parameter" "vpc_id" {
  name = "/E-comApp/vpc/vpc_id"
  with_decryption = true
}

# Fetching VPC CIDR from SSM Parameter Store
data "aws_ssm_parameter" "vpc_cidr" {
  name = "/E-comApp/vpc/vpc_cidr"
  with_decryption = true
}

# Fetching Subnet IDs from SSM Parameter Store
data "aws_ssm_parameter" "subnet_ids" {
  name = "/E-comApp/vpc/subnet_ids"
  with_decryption = true
}

# Fetching TLS certificate ARN from SSM Parameter Store
data "aws_ssm_parameter" "tls_cert" {
  name = "/E-comApp/global/acm/certificate/tls_cert_arn"
  with_decryption = true
}

# Fetching route53 zone IDs from SSM Parameter Store
data "aws_ssm_parameter" "zone_id" {
  name = "/E-comApp/route53/zone_id"
  with_decryption = true
}

# Fetching account ID from SSM Parameter Store
data "aws_ssm_parameter" "account_id" {
  name = "/E-comApp/aws/id"
  with_decryption = true
}
####################################   edit  ################################