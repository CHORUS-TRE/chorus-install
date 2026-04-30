output "oidc_secret_names" {
  description = "Names of OIDC client secrets created"
  value       = keys(var.oidc_client_secrets)
}
