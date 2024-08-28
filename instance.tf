resource "aws_instance" "ubuntu_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    # Update the package list
    sudo apt-get update -y

    # Install dependencies
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

    # Install Docker
    sudo apt install -y docker.io
    sudo apt install -y git
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ubuntu
    sudo 

    # Install Minikube
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    chmod +x minikube
    sudo mv minikube /usr/local/bin/

    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/

    # Start Minikube
    minikube start --driver=docker --ports=80:80
    minikube addons enable metrics-server
    minikube addons enable dashboard
    minikube addons enable ingress
    minikube dashboard --port=7000
  EOF

  tags = {
    Name = "Terraform-EC2-Ubuntu-Docker-Minikube"
  }

  # Define a security group allowing SSH and HTTP access
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  # Associate the Elastic IP with this instance
  associate_public_ip_address = true
}