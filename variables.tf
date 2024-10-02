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