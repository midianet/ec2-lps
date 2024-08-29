resource "aws_instance" "minikube" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    # Update the package list
    sudo apt update -y

    # Instalando dependencias
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common git

    # Instalando Docker
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ubuntu && newgrp docker
  
    # Instalando Minikube
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    #sudo install minikube-linux-amd64 /usr/local/bin/minikube
    sudo chmod +x minikube
    sudo mv minikube /usr/local/bin/

    # Instalando kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo chmod +x kubectl
    sudo mv kubectl /usr/local/bin/

    sudo su - ubuntu -c "newgrp docker && minikube start --driver=docker --memory=2048 --cpus=2 --ports=80:80 --addons=metrics-server --addons=ingress --addons=dashboard"
  EOF
  # 

  tags = {
    Name = "Terraform-EC2-Minikube"
  }

  # Define a security group allowing SSH and HTTP access
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  # Associate the Elastic IP with this instance
  associate_public_ip_address = true

}