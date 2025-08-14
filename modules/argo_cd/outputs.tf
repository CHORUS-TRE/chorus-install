output "argocd_url" {
  value = try("https://${local.argocd_values_parsed.argo-cd.global.domain}", null)
}

output "argocd_grpc_url" {
  value = try("https://grpc.${local.argocd_values_parsed.argo-cd.global.domain}", null)
}

output "argocd_username" {
  # admin username cannot be modified in the chart, only enabled/disabled
  value       = "admin"
  description = "ArgoCD username"
}

output "argocd_password" {
  value       = try(data.kubernetes_secret.argocd_admin_password.data.password, null)
  description = "ArgoCD password"
  sensitive   = true
}