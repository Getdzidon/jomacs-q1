
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "bucket_name" {
  default     = "harridee-tf-state-bucket"
  description = "Name of the S3 bucket for storing terraform.tfstate file"
}
