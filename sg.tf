# security grp for k8s cluster
resource "aws_security_group" "k8s_sg" {
  name   = "K8S Ports"
  vpc_id = aws_vpc.some_custom_vpc.id

  dynamic "ingress" {
    for_each = {
      "http" = {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
      }
      "https" = {
        from_port = 443
        to_port   = 443
        protocol  = "tcp"
      }
      "argo_api" = {
        from_port = 8080
        to_port   = 8080
        protocol  = "tcp"
      }
      "etcd" = {
        from_port = 2379
        to_port   = 2380
        protocol  = "tcp"
      }
      "k8s_api" = {
        from_port = 6443
        to_port   = 6443
        protocol  = "tcp"
      }
      "tiller" = {
        from_port = 44134
        to_port   = 44134
        protocol  = "tcp"
      }
      "prometheus" = {
        from_port = 9090
        to_port   = 9090
        protocol  = "tcp"
      }
      "NodeExporter" = {
        from_port = 9100
        to_port   = 9100
        protocol  = "tcp"
      }
      "grafana" = {
        from_port = 3000
        to_port   = 3000
        protocol  = "tcp"
      }
      "elasticsearch" = {
        from_port = 9200
        to_port   = 9200
        protocol  = "tcp"
      }
      "kibana" = {
        from_port = 5601
        to_port   = 5601
        protocol  = "tcp"
      }
      "datadog_apm" = {
        from_port = 8126
        to_port   = 8126
        protocol  = "tcp"
      }
      "datadog_statsd" = {
        from_port = 8125
        to_port   = 8125
        protocol  = "udp"
      }
      "ssh" = {  # Adding SSH configuration
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
      }
      "kubelet" = {  # Port for Kubelet API
        from_port = 10250
        to_port   = 10250
        protocol  = "tcp"
      }
      "node_ports" = {  # NodePort range
        from_port = 30000
        to_port   = 32767
        protocol  = "tcp"
      }
    }

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]  # Adjust as necessary for security
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#****** VPC END ******#
