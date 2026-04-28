output "admin_password" {
  value     = random_password.admin_password.result
  sensitive = true
}

output "alertmanager_client_secret" {
  value     = random_password.alertmanager_client_secret.result
  sensitive = true
}

output "argo_workflows_client_secret" {
  value     = var.cluster_type == "build" ? random_password.argo_workflows_client_secret.result : null
  sensitive = true
}

output "argocd_client_secret" {
  value     = var.cluster_type == "build" ? random_password.argocd_client_secret.result : null
  sensitive = true
}

output "chorus_client_secret" {
  value     = var.cluster_type == "build" ? null : random_password.chorus_client_secret.result
  sensitive = true
}

output "grafana_client_secret" {
  value     = random_password.grafana_client_secret.result
  sensitive = true
}

output "harbor_client_secret" {
  value     = random_password.harbor_client_secret.result
  sensitive = true
}

output "juicefs_dashboard_client_secret" {
  value     = var.cluster_type == "build" ? null : random_password.juicefs_dashboard_client_secret.result
  sensitive = true
}

output "matomo_client_secret" {
  value     = var.cluster_type == "build" ? null : random_password.matomo_client_secret.result
  sensitive = true
}

output "prometheus_client_secret" {
  value     = random_password.prometheus_client_secret.result
  sensitive = true
}

output "remotestate_encryption_key" {
  value     = random_password.remotestate_encryption_key.result
  sensitive = true
}
