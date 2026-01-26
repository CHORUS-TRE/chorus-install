output "keycloak_password" {
  value       = try(data.kubernetes_secret.keycloak_admin_password.data["${var.keycloak_secret_key}"], null)
  description = "Keycloak password"
  sensitive   = true
}

output "keycloak_db_password" {
  value       = try(module.db_secret.db_password, null)
  description = "Keycloak DB password for Keycloak user"
  sensitive   = true
}

output "keycloak_db_admin_password" {
  value       = try(module.db_secret.db_admin_password, null)
  description = "Keycloak DB password for Postgres user"
  sensitive   = true
}

output "argocd_keycloak_client_secret" {
  value       = var.cluster_type == "build" ? random_password.argocd_keycloak_client_secret.result : null
  description = "ArgoCD Keycloak client secret"
  sensitive   = true
}

output "argo_workflows_keycloak_client_secret" {
  value       = var.cluster_type == "build" ? random_password.argo_workflows_keycloak_client_secret.result : null
  description = "Argo Workflows Keycloak client secret"
  sensitive   = true
}

output "grafana_keycloak_client_secret" {
  value       = random_password.grafana_keycloak_client_secret.result
  description = "Grafana Keycloak client secret"
  sensitive   = true
}

output "alertmanager_keycloak_client_secret" {
  value       = random_password.alertmanager_keycloak_client_secret.result
  description = "Alertmanager Keycloak client secret"
  sensitive   = true
}

output "prometheus_keycloak_client_secret" {
  value       = random_password.prometheus_keycloak_client_secret.result
  description = "Prometheus Keycloak client secret"
  sensitive   = true
}

output "harbor_keycloak_client_secret" {
  value       = random_password.harbor_keycloak_client_secret.result
  description = "Harbor Keycloak client secret"
  sensitive   = true
}

output "matomo_keycloak_client_secret" {
  value       = var.cluster_type == "build" ? null : random_password.matomo_keycloak_client_secret.result
  description = "Matomo Keycloak client secret"
  sensitive   = true
}

output "chorus_keycloak_client_secret" {
  value       = var.cluster_type == "build" ? null : random_password.chorus_keycloak_client_secret.result
  description = "Chorus Keycloak client secret"
  sensitive   = true
}
