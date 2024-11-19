output "public_ip_address" {
  value = azurerm_public_ip.default.ip_address
}

output "managed_identity_principal_id" {
  value = azurerm_linux_virtual_machine.default.identity[0].principal_id
}

output "network_interface_id" {
  value = azurerm_network_interface.default.id
}
