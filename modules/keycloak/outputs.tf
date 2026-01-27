output "alertmanager_keycloak_client_secret" {
  value       = module.keycloak_secret.alertmanager_client_secret
  description = "Alertmanager Keycloak client secret"
  sensitive   = true
}

output "argo_workflows_keycloak_client_secret" {
  value       = module.keycloak_secret.argo_workflows_client_secret
  description = "Argo Workflows Keycloak client secret"
  sensitive   = true
}

output "argocd_keycloak_client_secret" {
  value       = module.keycloak_secret.argocd_client_secret
  description = "ArgoCD Keycloak client secret"
  sensitive   = true
}

output "grafana_keycloak_client_secret" {
  value       = module.keycloak_secret.grafana_client_secret
  description = "Grafana Keycloak client secret"
  sensitive   = true
}

output "harbor_keycloak_client_secret" {
  value       = module.keycloak_secret.harbor_client_secret
  description = "Harbor Keycloak client secret"
  sensitive   = true
}

output "keycloak_db_admin_password" {
  value       = module.db_secret.db_admin_password
  description = "Keycloak DB password for Postgres user"
  sensitive   = true
}

output "keycloak_db_password" {
  value       = module.db_secret.db_password
  description = "Keycloak DB password for Keycloak user"
  sensitive   = true
}

output "keycloak_password" {
  value       = module.keycloak_secret.admin_password
  description = "Keycloak password"
  sensitive   = true
}

output "prometheus_keycloak_client_secret" {
  value       = module.keycloak_secret.prometheus_client_secret
  description = "Prometheus Keycloak client secret"
  sensitive   = true
}
