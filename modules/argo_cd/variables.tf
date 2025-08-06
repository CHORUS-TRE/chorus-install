variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string
}

variable "helm_registry" {
  description = "Helm chart registry to get the chart from"
  type        = string
}

variable "argocd_chart_name" {
  description = "ArgoCD Helm chart name"
  type        = string
}

variable "argocd_chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
}

variable "argocd_helm_values" {
  description = "ArgoCD Helm chart values"
  type        = string
}

variable "argocd_namespace" {
  description = "Namespace to deploy ArgoCD Helm chart into"
  type        = string
}

variable "argocd_cache_chart_name" {
  description = "ArgoCD cache (e.g. Valkey) Helm chart name"
  type        = string
}

variable "argocd_cache_chart_version" {
  description = "ArgoCD cache (e.g. Valkey) Helm chart version"
  type        = string
}

variable "argocd_cache_helm_values" {
  description = "ArgoCD cache (e.g. Valkey) Helm chart values"
  type        = string
}

variable "helm_charts_values_credentials_secret" {
  description = "Secret to store the Helm charts values repository credentials in"
  type        = string
}

variable "helm_values_url" {
  description = "Repository where to get the Helm charts values from"
  type        = string
}

variable "helm_values_pat" {
  description = "Fine-grained personal access token (PAT) to access the environments repository"
  type        = string
  sensitive   = true
}

variable "harbor_domain" {
  description = "Harbor OCI registry domain"
  type        = string
}

variable "harbor_robot_username" {
  description = "Username of the robot used to connect to Harbor"
  type        = string
}

variable "harbor_robot_password" {
  description = "Password of the robot used to connect to Harbor"
  type        = string
}

variable "remote_clusters" {
  description = "Map of remote cluster configurations for ArgoCD"
  type = map(object({
    name   = string
    server = string
    config = object({
      bearer_token = optional(string)
      tls_client_config = optional(object({
        insecure = optional(bool, false)
        ca_data  = optional(string)
      }))
    })
  }))
  default = {}
  validation {
    condition = alltrue([
      for cluster_name, cluster_config in var.remote_clusters :
      can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", cluster_name))
    ])
    error_message = "Cluster names must be valid Kubernetes resource names (lowercase alphanumeric and hyphens only)."
  }
}