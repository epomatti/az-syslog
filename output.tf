output "vm_public_ip_address" {
  value = module.vm_syslog.public_ip_address
}

output "vm_ssh_connect_command" {
  value = "ssh -i keys/temp_rsa ${var.vm_username}@${module.vm_syslog.public_ip_address}"
}
