output "master_public_ip" {
  description = "Public IP address of the Kubernetes master node"
  value       = aws_instance.ec2_instance_msr.public_ip
}

output "worker_public_ips" {
  description = "List of public IP addresses of Kubernetes worker nodes"
  value       = aws_instance.ec2_instance_wrk.*.public_ip
}

output "vpc_id" {
  description = "ID of the VPC created for the Kubernetes cluster"
  value       = aws_vpc.some_custom_vpc.id
}

output "security_group_id" {
  description = "ID of the security group used for Kubernetes cluster"
  value       = aws_security_group.k8s_sg.id
}