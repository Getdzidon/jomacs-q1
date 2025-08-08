# Create an S3 bucket for Terraform state management
# This bucket will be used to store the Terraform state file securely.

resource "aws_s3_bucket" "tfstate-bucket" {
  bucket = var.bucket_name

  tags = {
    Name    = var.bucket_name
    Project = "jomacs_q1"
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate-bucket-policy" {
  bucket = aws_s3_bucket.tfstate-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

