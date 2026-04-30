output "oidc_secret_names" {
  description = "Names of OIDC client secrets created"
  value       = keys(kubernetes_secret.oidc_client_secrets)
}
