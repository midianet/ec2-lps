variable "aws_region" {
  description = "Região AWS."
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID da imagem Ubuntu."
  default     = "ami-0e86e20dae9224db8" # Ubuntu 24.04 LTS in us-east-1
}

variable "instance_type" {
  description = "Tipo de instância EC2. T2 Medium"
  default     = "t2.medium"
}

variable "key_name" {
  description = "Nome da SSH key pair."
  default     = "lps-poc"
}