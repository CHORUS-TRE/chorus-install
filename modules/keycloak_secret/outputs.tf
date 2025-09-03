output "keycloak_password" {
  value       = try(random_password.keycloak_password.result, null)
  description = "Keycloak password"
  sensitive   = true
}