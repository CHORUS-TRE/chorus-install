output "argocd_url" {
  value = "https://${local.argocd_values_parsed.argo-cd.global.domain}"
}

output "argocd_grpc_url" {
  value = "https://grpc.${local.argocd_values_parsed.argo-cd.global.domain}"
}

output "argocd_username" {
  # admin username cannot be modified in the chart, only enabled/disabled
  value       = "admin"
  description = "ArgoCD username"
}

output "argocd_password" {
  value       = data.kubernetes_secret.argocd_admin_password.data.password
  description = "ArgoCD password"
  sensitive   = true
}