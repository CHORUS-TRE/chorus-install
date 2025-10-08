output "keycloak_password" {
  description = "The generated Keycloak admin password"
  value       = random_password.keycloak_password.result
  sensitive   = true
}