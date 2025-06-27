variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string
}

variable "argocd_helm_values" {
  description = "ArgoCD Helm chart values"
  type        = string
}

variable "helm_values_url" {
  description = "Repository where to get the Helm charts values from"
  type = string
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

variable "helm_values_revision" {
  description = "Helm charts values repository revision"
  type        = string
}

variable "harbor_domain" {
  description = "Harbor OCI registry domain"
  type        = string
}

variable "kubeconfig_path" {
  description = "Path to the Kubernetes config file"
  type        = string
}

variable "kubeconfig_context" {
  description = "Kubernetes context to use"
  type        = string
}