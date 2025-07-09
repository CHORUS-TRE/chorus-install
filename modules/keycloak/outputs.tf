output "keycloak_url" {
  value = "https://${local.keycloak_values_parsed.keycloak.ingress.hostname}"
}

output "keycloak_password" {
  value       = data.kubernetes_secret.keycloak_admin_password.data["${local.keycloak_values_parsed.keycloak.auth.passwordSecretKey}"]
  description = "Keycloak password"
  sensitive   = true
}