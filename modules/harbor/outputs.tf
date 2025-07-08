output "harbor_username" {
  value       = var.harbor_admin_username
  description = "Harbor username"
}

output "harbor_password" {
  value       = data.kubernetes_secret.harbor_admin_password.data["${local.harbor_values_parsed.harbor.existingSecretAdminPasswordKey}"]
  description = "Harbor password"
  sensitive   = true
}

output "harbor_url" {
  value       = local.harbor_values_parsed.harbor.externalURL
  description = "Harbor URL"
}

output "harbor_url_admin_login" {
  value       = join("/", [local.harbor_values_parsed.harbor.externalURL, "account/sign-in"])
  description = "Harbor URL to login with local DB admin user"
}