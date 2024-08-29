output "instance_id" {
  value = aws_instance.minikube.id
}

output "instance_public_ip" {
  value = aws_eip.elastic_ip.public_ip
}