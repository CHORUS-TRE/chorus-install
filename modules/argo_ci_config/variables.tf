variable "argocd_namespace" {
  description = "Namespace where ArgoCD is deployed"
  type        = string
}

variable "argoci_github_workbench_operator_token" {
  description = "GitHub token for the Workbench Operator repository"
  type        = string
  sensitive   = true
}

variable "argoci_github_chorus_web_ui_token" {
  description = "GitHub token for the Chorus Web UI repository"
  type        = string
  sensitive   = true
}

variable "argoci_github_images_token" {
  description = "GitHub token for the Images repository"
  type        = string
  sensitive   = true
}

variable "argoci_github_chorus_backend_token" {
  description = "GitHub token for the Chorus Backend repository"
  type        = string
  sensitive   = true
}
