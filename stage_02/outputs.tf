output "argocd_url" {
  value = try(module.argo_cd.argocd_url,
  "Failed to retrieve ArgoCD URL")
}

output "argocd_username" {
  value = try(module.argo_cd.argocd_username,
  "Failed to retrieve ArgoCD admin username ")
}

output "argocd_password" {
  value     = module.argo_cd.argocd_password
  sensitive = true
}