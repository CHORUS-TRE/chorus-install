output "harbor_admin_username" {
  description = "Harbor admin username"
  value       = var.harbor_admin_username
}

output "harbor_admin_password" {
  description = "Harbor admin password"
  value       = local.harbor_admin_password
  sensitive   = true
}

output "harbor_url" {
  description = "Harbor URL"
  value       = local.harbor_url
}

output "harbor_admin_url" {
  description = "Harbor admin login URL"
  value       = join("/", [local.harbor_url, "account", "sign-in"])
}

output "keycloak_admin_username" {
  description = "Keycloak admin username"
  value       = var.keycloak_admin_username
}

output "keycloak_admin_password" {
  description = "Keycloak admin password"
  value       = local.keycloak_admin_password
  sensitive   = true
}

output "keycloak_url" {
  description = "Keycloak URL"
  value       = local.keycloak_url
}

output "prometheus_url" {
  description = "Prometheus URL"
  value       = local.prometheus_url
}

output "alertmanager_url" {
  description = "Alertmanager URL"
  value       = local.alertmanager_url
}

output "grafana_url" {
  description = "Grafana URL"
  value       = local.grafana_url
}

output "grafana_admin_username" {
  description = "Grafana admin username"
  value       = var.grafana_admin_username
}

output "grafana_admin_password" {
  description = "Grafana admin password"
  value       = random_password.grafana_admin_password.result
  sensitive   = true
}

output "matomo_url" {
  description = "Matomo URL"
  value       = local.matomo_url
}

output "frontend_url" {
  description = "Frontend URL"
  value       = local.frontend_url
}

output "backend_url" {
  description = "Backend URL"
  value       = local.backend_url
}

output "didata_url" {
  description = "DiData URL"
  value       = local.didata_url
}