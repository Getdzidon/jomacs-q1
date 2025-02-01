######### S3 Bucket Resource (Main Bucket Configuration) ##########
resource "aws_s3_bucket" "E-comApp" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
  }
}
