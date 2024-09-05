#!/bin/bash

# Variables
HOST_PRIVATE_IP=$(hostname -I | awk '{print $1}')
KUBERNETES_VERSION="1.30"
POD_NETWORK_CIDR="10.244.0.0/16"
S3_BUCKET_NAME="bucketforcicd117"

# Update and upgrade system packages
sudo apt-get update -y && sudo apt-get upgrade -y

# Install necessary packages
sudo apt-get install -y net-tools apt-transport-https ca-certificates curl gpg

# Turn off swap
swapoff -a
sudo sed -i '/swap/d' /etc/fstab
mount -a
ufw disable

# Configure kernel modules for containerd
cat > /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

# Apply sysctl settings for Kubernetes networking
cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system

# Install Docker dependencies
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y

# Install containerd
sudo apt-get install -y containerd.io

# Configure containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# Restart containerd
sudo systemctl restart containerd
#sudo systemctl status containerd

# Configure crictl
cat > /etc/crictl.yaml <<EOF
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
EOF

# Add Kubernetes repository
sudo apt-get update -y
# apt-transport-https may be a dummy package; if so, you can skip that package
#sudo apt-get install -y apt-transport-https ca-certificates curl gpg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# # Install Kubernetes components
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Initialize Kubernetes master node
sudo kubeadm init --apiserver-advertise-address="$HOST_PRIVATE_IP" --cri-socket=/run/containerd/containerd.sock --pod-network-cidr="$POD_NETWORK_CIDR" > /tmp/result.out
#cat /tmp/restult.out

#this adds .kube/config for root account, run same for ubuntu user, if you need it
mkdir -p /root/.kube;
cp -i /etc/kubernetes/admin.conf /root/.kube/config;
cp -i /etc/kubernetes/admin.conf /tmp/admin.conf;
chmod 755 /tmp/admin.conf

#Add kube config to ubuntu user.
mkdir -p /home/ubuntu/.kube;
cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config;
chmod 755 /home/ubuntu/.kube/config

# Install Calico CNI
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/tigera-operator.yaml
wget https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/custom-resources.yaml 

# Replace default IP in custom-resources.yaml with POD_NETWORK_CIDR
sed -i "s|192.168.0.0/16|$POD_NETWORK_CIDR|g" custom-resources.yaml
kubectl apply -f custom-resources.yaml

# To get join command
tail -2 /tmp/result.out > /tmp/join_command.sh;
aws s3 cp /tmp/join_command.sh s3://${S3_BUCKET_NAME};


