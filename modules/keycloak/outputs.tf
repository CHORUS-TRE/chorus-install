output "keycloak_password" {
  value       = data.kubernetes_secret.keycloak_admin_password.data["${var.keycloak_secret_key}"]
  description = "Keycloak password"
  sensitive   = true
}

output "keycloak_db_password" {
  value       = random_password.keycloak_db_password.result
  description = "Keycloak DB password for Keycloak user"
  sensitive   = true
}

output "keycloak_db_admin_password" {
  value       = random_password.keycloak_db_admin_password.result
  description = "Keycloak DB password for Postgres user"
  sensitive   = true
}