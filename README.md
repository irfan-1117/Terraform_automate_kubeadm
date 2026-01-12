# Terraform Kubernetes Cluster with Kubeadm

Automated Terraform configuration to deploy a production-ready Kubernetes cluster on AWS using kubeadm.

## 📋 Prerequisites

- Terraform >= 1.5.0
- AWS CLI configured with appropriate credentials
- SSH key pair for EC2 access
- Basic understanding of Kubernetes and AWS

## 🏗️ Architecture

This Terraform configuration creates:
- Custom VPC (10.0.0.0/16) with public subnet
- 1 Master node (t3.medium) for Kubernetes control plane
- N Worker nodes (configurable, default: 2) for workloads
- Security groups with necessary Kubernetes ports (6443, 10250, 30000-32767, etc.)
- IAM roles and instance profiles with least privilege access
- Automated kubeadm installation and cluster initialization via user data scripts

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/irfan-1117/Terraform_automate_kubeadm.git
   cd Terraform_automate_kubeadm
   ```

2. **Generate SSH key pair** (if you don't have one)
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/k8s-cluster-key -N ""
   ```

3. **Configure variables**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your actual values
   nano terraform.tfvars
   ```

4. **Initialize Terraform**
   ```bash
   terraform init
   ```

5. **Review the plan**
   ```bash
   terraform plan
   ```

6. **Apply configuration**
   ```bash
   terraform apply
   ```

7. **Access your cluster**
   ```bash
   # SSH to master node
   ssh -i ~/.ssh/k8s-cluster-key ubuntu@<master-public-ip>
   
   # Get cluster status
   kubectl get nodes
   ```

## ⚙️ Configuration

### Required Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `region` | AWS region to deploy resources | `us-east-1` | No |
| `instance_type` | EC2 instance type for nodes | `t3.medium` | No |
| `number_of_worker` | Number of worker nodes | `2` | No |
| `ami_id` | Ubuntu AMI ID | `ami-04a81a99f5ec58529` | No |
| `s3_bucket_name` | S3 bucket for CI/CD artifacts | - | **Yes** |
| `key_name` | Name for AWS key pair | `k8s-cluster-key` | No |
| `public_key_content` | SSH public key content | - | **Yes** |
| `allowed_ssh_cidr` | CIDR blocks allowed for SSH | `["0.0.0.0/0"]` | No |

### Example terraform.tfvars

```hcl
region             = "us-east-1"
instance_type      = "t3.medium"
number_of_worker   = 2
s3_bucket_name     = "my-k8s-cluster-bucket"
key_name           = "k8s-cluster-key"
public_key_content = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC..."
allowed_ssh_cidr   = ["203.0.113.0/24"]  # Replace with your IP
ami_id             = "ami-04a81a99f5ec58529"
```

## 🔒 Security Best Practices

- [ ] **Restrict SSH access**: Update `allowed_ssh_cidr` to your specific IP range
- [ ] **Use secrets manager**: Store sensitive data in AWS Secrets Manager
- [ ] **Enable VPC flow logs**: Monitor network traffic
- [ ] **Implement least privilege**: Review and restrict IAM policies further if needed
- [ ] **Enable EBS encryption**: Add encryption for block devices
- [ ] **Use private subnets**: Consider moving worker nodes to private subnets
- [ ] **Enable AWS CloudTrail**: Track all API calls for audit
- [ ] **Regular updates**: Keep AMI and Kubernetes versions updated

## 📤 Outputs

After successful deployment, Terraform outputs:
- `master_public_ip`: Public IP of the master node
- `worker_public_ips`: List of worker node public IPs
- `vpc_id`: ID of the created VPC
- `security_group_id`: ID of the Kubernetes security group

## 🛠️ Maintenance

### Scale Worker Nodes

```bash
# Update terraform.tfvars
number_of_worker = 3

# Apply changes
terraform apply
```

### Update Resources

```bash
terraform plan
terraform apply
```

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Warning**: This will permanently delete all resources created by Terraform.

## 🐛 Troubleshooting

### Cluster nodes not joining
- Check security group rules allow communication between nodes
- Verify user data scripts executed successfully: `sudo cat /var/log/cloud-init-output.log`

### SSH connection issues
- Verify your IP is in `allowed_ssh_cidr`
- Check key pair is correctly configured
- Ensure instance has public IP assigned

### Terraform errors
- Run `terraform fmt` to fix formatting issues
- Run `terraform validate` to check configuration syntax
- Check AWS credentials are properly configured

## 📚 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [kubeadm Documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**irfan-1117**
- GitHub: [@irfan-1117](https://github.com/irfan-1117)

## ⭐ Show Your Support

Give a ⭐️ if this project helped you! 
