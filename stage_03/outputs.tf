output "harbor_url" {
  value = try(local.harbor_values_parsed.harbor.externalURL,
  "Failed to retrieve Harbor URL")
}

output "harbor_url_admin_login" {
  value = try(join("/", [local.harbor_values_parsed.harbor.externalURL, "account/sign-in"]),
  "Failed to retrieve Harbor URL to login with local DB admin user")
}

output "harbor_username" {
  value = try(module.harbor_secret.harbor_username,
  "Failed to retrieve Harbor URL")
}

output "harbor_password" {
  value     = module.harbor_secret.harbor_password
  sensitive = true
}

output "keycloak_url" {
  value = try(local.keycloak_url,
  "Failed to retrieve Keycloak URL")
}

output "keycloak_password" {
  value     = module.keycloak_secret.keycloak_password
  sensitive = true
}

output "harbor_oidc_config" {
  value = local.harbor_oidc_config
}

output "harbor_oidc_config2" {
  value = local.harbor_oidc_config2
}