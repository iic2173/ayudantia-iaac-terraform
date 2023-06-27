# Output to dislay after `terraform apply`
output "elastic_ip" {
  value = aws_eip.main.public_ip
}

output "ssh_command" {
  value = "ssh -i ${aws_instance.main.key_name}.pem ubuntu@${aws_eip.main.public_ip}"
}
