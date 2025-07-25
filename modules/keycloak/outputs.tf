output "keycloak_url" {
  value = "https://${local.keycloak_values_parsed.keycloak.ingress.hostname}"
}

output "keycloak_password" {
  value       = data.kubernetes_secret.keycloak_admin_password.data["${local.keycloak_values_parsed.keycloak.auth.passwordSecretKey}"]
  description = "Keycloak password"
  sensitive   = true
}

output "keycloak_db_password" {
  value       = random_password.keycloak_db_password.result
  description = "Keycloak DB password for Keycloak user"
  sensitive = true
}

output "keycloak_db_admin_password" {
  value       = random_password.keycloak_db_admin_password.result
  description = "Keycloak DB password for Postgres user"
  sensitive = true
}