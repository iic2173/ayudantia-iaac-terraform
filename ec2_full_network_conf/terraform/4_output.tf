# Output to dislay after `terraform apply`

output "a0_enviroment" {
  value = var.tags.Environment
}

output "ec2_web_server---elastic_ip" {
  value = module.ec2_web_server.elastic_ip
}

output "ec2_web_server---ssh_command" {
  value = module.ec2_web_server.ssh_command
}
