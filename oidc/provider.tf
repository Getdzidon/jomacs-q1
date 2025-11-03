# AWS Provider Configuration
# Note: Ensure the S3 bucket is created manually (or with a different terraform configuration) before running this configuration.

# Note: the backend values here are hardcodded because the backend "(terraform { backend "s3" { ... } })" is initialized before any variables or data sources are evaluated. Terraform needs to know where to find your state file before it can evaluate anything else.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.19.0"
    }
  }

  backend "s3" {
    bucket = "deebest-tf-state-bucket"      # Replace with your S3 bucket name (manually created)
    key    = "secretes/OIDC/oidc.tfstate"   # The path within the bucket
    region = "eu-central-1"                 # S3 bucket region
    # use_lockfile = true                      
  }
  
}
provider "aws" {
  region = "eu-central-1"
}