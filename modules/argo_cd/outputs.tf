output "argocd_url" {
  value = try("https://${local.argocd_values_parsed.argo-cd.global.domain}", "ArgoCD URL not available")
}

output "argocd_grpc_url" {
  value = try("https://grpc.${local.argocd_values_parsed.argo-cd.global.domain}", "ArgoCD GRPC URL not available")
}

output "argocd_username" {
  # admin username cannot be modified in the chart, only enabled/disabled
  value = "admin"
}

output "argocd_password" {
  value     = try(data.kubernetes_secret.argocd_admin_password.data.password, "ArgoCD password not available")
  sensitive = true
}