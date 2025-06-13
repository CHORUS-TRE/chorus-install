variable "argocd_helm_values_path" {
  description = "Path to the ArgoCD Helm chart values"
  type        = string
}

variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string
}

variable "oidc_endpoint" {
  description = "OIDC server endpoint"
  type        = string
}

variable "oidc_client_id" {
  description = "OIDC client ID"
  type        = string
}

variable "oidc_client_secret" {
  description = "OIDC client secret"
  type        = string
}

variable "helm_values_url" {
  description = "Helm charts values repository URL"
  type        = string
}

variable "helm_values_revision" {
  description = "Helm charts values repository revision"
  type        = string
}

variable "helm_chart_repository_url" {
  description = "Helm chart repository URL"
  type        = string
}