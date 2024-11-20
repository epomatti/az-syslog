output "vm_syslog_server_ssh_connect_command" {
  value = "ssh -i keys/temp_rsa ${var.vm_username}@${module.vm_syslog_server.public_ip_address}"
}

output "vm_syslog_client_ssh_connect_command" {
  value = "ssh -i keys/temp_rsa ${var.vm_username}@${module.vm_syslog_client.public_ip_address}"
}
