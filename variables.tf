variable "number_of_worker" {
  description = "number of worker instances to be join on cluster."
  default     = 2
}

variable "region" {
  description = "The region zone on AWS"
  default     = "us-east-1" #The zone I selected is us-east-1, if you change it make sure to check if ami_id below is correct.
}

variable "ami_id" {
  description = "The AMI to use"
  default     = "ami-04a81a99f5ec58529" #Ubuntu 20.04
}

variable "instance_type" {
  default = "t3.medium" #the best type to start k8s with it,
}

variable "s3_bucket_name" {
  description = "S3 bucket name for CI/CD and cluster artifacts"
  type        = string
  sensitive   = true
}

variable "key_name" {
  description = "Name for AWS key pair"
  type        = string
  default     = "k8s-cluster-key"
}

variable "public_key_content" {
  description = "Public SSH key content (use ssh-keygen to generate)"
  type        = string
  sensitive   = true
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed for SSH access (restrict to your IP for security)"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Change this in production!
}
