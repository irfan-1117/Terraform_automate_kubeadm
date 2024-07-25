# Create Key Pair for SSH access
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
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  security_groups             = [aws_security_group.k8s_sg.id]
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "16"
    delete_on_termination = true
  }
  tags = {
    Name = "k8s_msr_1"
  }
  user_data_base64 = base64encode("${templatefile("scripts/install_k8s_msr.sh", {

    region        = var.region
    s3buckit_name = "k8s-${random_string.s3name.result}"
  })}")

  depends_on = [
    aws_s3_bucket.s3buckit,
    random_string.s3name
  ]


}

resource "aws_instance" "ec2_instance_wrk" {
  ami                         = var.ami_id
  count                       = var.number_of_worker
  subnet_id                   = aws_subnet.some_public_subnet.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name # Use the created key pair for SSH access
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  security_groups             = [aws_security_group.k8s_sg.id]
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "16"
    delete_on_termination = true
  }
  tags = {
    Name = "k8s_wrk_${count.index + 1}"
  }
  user_data_base64 = base64encode("${templatefile("scripts/install_k8s_wrk.sh", {

    region        = var.region
    s3buckit_name = "k8s-${random_string.s3name.result}"
    worker_number = "${count.index + 2}"

  })}")

  depends_on = [
    aws_s3_bucket.s3buckit,
    random_string.s3name,
    aws_instance.ec2_instance_msr
  ]
} 