output "instance_id" {
  value = aws_instance.ubuntu_instance.id
}

output "instance_public_ip" {
  value = aws_eip.elastic_ip.public_ip
}