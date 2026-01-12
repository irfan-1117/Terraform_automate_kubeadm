terraform {
  backend "s3" {
    # NOTE: Backend configuration does not support variable interpolation.
    # Either:
    # 1. Update this value manually to match your S3 bucket
    # 2. Use -backend-config flag: terraform init -backend-config="bucket=your-bucket-name"
    # 3. Use a backend config file: terraform init -backend-config=backend.hcl
    bucket  = "bucketforcicd117"      # Replace with your S3 bucket name
    key     = "dev/terraform.tfstate" # Path to the state file in the bucket
    region  = "us-east-1"             # Match the region with the provider
    encrypt = true                    # Enable encryption for the state file
  }
}

