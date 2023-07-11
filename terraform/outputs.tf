output "Master-IP" {
  value = azurerm_public_ip.master-pubip.ip_address
}

output "Worker-1-IP" {
  value = azurerm_public_ip.worker1-pubip.ip_address
}

output "Worker-2-IP" {
  value = azurerm_public_ip.worker2-pubip.ip_address
}
