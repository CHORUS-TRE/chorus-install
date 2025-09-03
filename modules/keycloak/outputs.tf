output "keycloak_password" {
  value       = try(data.kubernetes_secret.keycloak_admin_password.data["${var.keycloak_secret_key}"], null)
  description = "Keycloak password"
  sensitive   = true
}

output "keycloak_db_password" {
  value       = try(module.db_secret.db_password, null)
  description = "Keycloak DB password for Keycloak user"
  sensitive   = true
}

output "keycloak_db_admin_password" {
  value       = try(module.db_secret.db_admin_password, null)
  description = "Keycloak DB password for Postgres user"
  sensitive   = true
}