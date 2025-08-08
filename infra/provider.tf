# AWS Provider Configuration

# Note: the backend values here are hardcodded because the backend "(terraform { backend "s3" { ... } })" is initialized before any variables or data sources are evaluated. 
# Terraform needs to know where to find your state file before it can evaluate anything else
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.7.0"
    }
  }
    backend "s3" {
    bucket = "deebest-tf-state-bucket"
    key    = "infrastructure/infra.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region
}
