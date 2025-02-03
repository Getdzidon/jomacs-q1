terraform {
  backend "s3" {
    bucket         = "harridee-ecom-app"
    key            = "infra/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}
