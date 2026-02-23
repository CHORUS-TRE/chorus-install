output "loki_client_passwords" {
  description = "Map of Loki client names to their generated passwords"
  value = {
    for client in var.loki_clients :
    client => random_password.loki_client_password[client].result
  }
  sensitive = true
}
