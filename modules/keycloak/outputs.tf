output "keycloak_password" {
  value       = try(data.kubernetes_secret.keycloak_admin_password.data["${var.keycloak_secret_key}"], null)
  description = "Keycloak password"
  sensitive   = true
}

output "keycloak_db_password" {
  value       = try(random_password.keycloak_db_password.result, null)
  description = "Keycloak DB password for Keycloak user"
  sensitive   = true
}

output "keycloak_db_admin_password" {
  value       = try(random_password.keycloak_db_admin_password.result, null)
  description = "Keycloak DB password for Postgres user"
  sensitive   = true
}