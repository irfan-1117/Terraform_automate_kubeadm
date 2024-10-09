# Create Key Pair for SSH access
locals {
  S3_BUCKET_NAME = "bucketforcicd117" # Replace with the actual value or variable
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "terraform_key"
  public_key = file("./my-aws-keypair.pub") # Change path accordingly
}

resource "aws_instance" "ec2_instance_msr" {
  ami                         = var.ami_id
  subnet_id                   = aws_subnet.some_public_subnet.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name # Use the created key pair for SSH access
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.combined_instance_profile.name
  security_groups             = [aws_security_group.k8s_sg.id]
  root_block_device {
    volume_type           = "gp3"
    volume_size           = "25"
    delete_on_termination = true
  }
  tags = {
    Name = "k8s_msr_1"
  }

  user_data_base64 = base64encode(templatefile("scripts/install_k8s_msr.sh", {
    S3_BUCKET_NAME = local.S3_BUCKET_NAME
  }))

}

resource "aws_instance" "ec2_instance_wrk" {
  ami                         = var.ami_id
  count                       = var.number_of_worker
  subnet_id                   = aws_subnet.some_public_subnet.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name # Use the created key pair for SSH access
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.combined_instance_profile.name
  security_groups             = [aws_security_group.k8s_sg.id]
  root_block_device {
    volume_type           = "gp3"
    volume_size           = "25"
    delete_on_termination = true
  }
  tags = {
    Name = "k8s_wrk_${count.index + 1}"
  }

  user_data_base64 = base64encode(templatefile("scripts/install_k8s_wrk.sh", {
    S3_BUCKET_NAME = local.S3_BUCKET_NAME
  }))

} 