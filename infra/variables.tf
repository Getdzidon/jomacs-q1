# Variables for Terraform Configuration
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

# variable "ami" {
#   description = "The AMI ID  to use for this instance."
#   type        = string
#   default     = "ami-07eef52105e8a2059"
# }

# variable "vpc_id" {
#   description = "ID of the default vpc"
#   default     = "vpc-0528dc4e6cbc1eb6c"
# }

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name of EC2 instance"
  default     = "harridee-market"
}

variable "keypair_name" {
  description = "Name of the key pair to use for the EC2 instance"
  type        = string
  default     = "Jomacs Demo"
}

variable "instance_count" {
  description = "The number of instances to launch."
  type        = number
  default     = 1
}

variable "domain_name" {
  description = "Domain name used for DNS record in Route 53"
  default     = "market.harridee.com" # placeholder for domain name
}

variable "alb_name" {
  description = "Application Load Balancer name"
  default     = "harridee-market-alb"
}

variable "waf_name" {
  description = "WAF name"
  default     = "harridee-market-waf"
}

variable "lb_target_group" {
  description = "Load Balancer Target group name"
  default     = "harridee-market-lb-tg"
}

# variable "bucket_name" {
#   default     = "harridee-tf-state-bucket"
#   description = "Name of the S3 bucket for storing terraform.tfstate file"
# }

# variable "s3_bucket_key" {
#   default     = "infrastructure/s3.tfstate"
#   description = "Key for the S3 bucket where the Terraform state file is stored"
# }
