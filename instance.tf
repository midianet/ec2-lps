resource "aws_instance" "ubuntu_instance" {
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
    sudo usermod -aG docker ubuntu
  
    # Instalando Minikube
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    chmod +x minikube
    sudo mv minikube /usr/local/bin/

    # Instalando kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/

    # Criando Minikube addons
    #cat <<EOT | sudo tee /usr/local/bin/setup-minikube-addons.sh > /dev/null
    ##!/bin/bash
    #minikube addons enable metrics-server
    #minikube addons enable dashboard
    #minikube addons enable ingress
    #EOT
    #sudo chmod +x /usr/local/bin/setup-minikube-addons.sh

    # Criando minikube.service
    cat <<EOT | sudo tee /etc/systemd/system/minikube.service > /dev/null
    [Unit]
    Description=Minikube Service
    After=docker.service
    Requires=docker.service
   
    [Service]
    ExecStart=/usr/local/bin/minikube start --driver=docker --ports=80:80 --addons default-storageclass storage-provisioner metrics-server dashboard ingress  
    ExecStop=/usr/local/bin/minikube stop
    Restart=always
    User=ubuntu
    Environment=HOME=/home/ubuntu

    [Install]
    WantedBy=multi-user.target
    EOT

    # Atualizando o sistema e iniciando o Minikube
    sudo systemctl daemon-reload
    sudo systemctl enable minikube
    sudo systemctl start minikube

    # Criando servico Minikube addons
    #cat <<EOT | sudo tee /etc/systemd/system/minikube-addons.service > /dev/null
    #[Unit]
    #Description=Minikube Addons Setup
    #After=minikube.service
    #Requires=minikube.service

    #[Service]
    #ExecStart=/usr/local/bin/setup-minikube-addons.sh
    #User=ubuntu
    #Environment=HOME=/home/ubuntu

    #[Install]
    #WantedBy=multi-user.target
    #EOT
    
    # Atualizando o sistema e iniciando o servico Minikube addons
    #sudo systemctl daemon-reload
    #sudo systemctl enable minikube-addons
    #sudo systemctl start minikube-addons

  EOF

  tags = {
    Name = "Terraform-EC2-Ubuntu-Docker-Minikube"
  }

  # Define a security group allowing SSH and HTTP access
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  # Associate the Elastic IP with this instance
  associate_public_ip_address = true
}