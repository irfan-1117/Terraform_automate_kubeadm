terraform {
  backend "s3" {
    bucket  = "bucketforcicd117"
    key     = "dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}