output "loadbalancer_ip" {
  value = try(module.ingress_nginx.loadbalancer_ip,
  "Failed to retrieve loadbalancer IP address")
}

output "harbor_url" {
  value = try(local.harbor_values_parsed.harbor.externalURL,
  "Failed to retrieve Harbor URL")
}

output "harbor_url_admin_login" {
  value = try(join("/", [local.harbor_values_parsed.harbor.externalURL, "account/sign-in"]),
  "Failed to retrieve Harbor URL to login with local DB admin user")
}

output "harbor_username" {
  value = try(module.harbor.harbor_username,
  "Failed to retrieve Harbor URL")
}

output "harbor_password" {
  value     = module.harbor.harbor_password
  sensitive = true
}

output "keycloak_url" {
  value = try(local.keycloak_url,
  "Failed to retrieve Keycloak URL")
}

output "keycloak_password" {
  value     = module.keycloak.keycloak_password
  sensitive = true
}