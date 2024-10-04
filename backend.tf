terraform {
  backend "s3" {
    bucket  = "bucketforcicd117"      # Use the same bucket name here
    key     = "dev/terraform.tfstate" # Path to the state file in the bucket
    region  = "us-east-1"             # Match the region with the provider
    encrypt = true                    # Enable encryption for the state file
  }
}


