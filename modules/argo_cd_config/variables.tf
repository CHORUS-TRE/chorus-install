variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "cluster_name cannot be empty."
  }
}

variable "argocd_helm_values" {
  description = "ArgoCD Helm chart values"
  type        = string

  validation {
    condition     = length(var.argocd_helm_values) > 0
    error_message = "argocd_helm_values cannot be empty."
  }
}

variable "argocd_namespace" {
  description = "Namespace to deploy ArgoCD Helm chart into"
  type        = string

  validation {
    condition     = length(var.argocd_namespace) > 0
    error_message = "argocd_namespace cannot be empty."
  }
}

variable "helm_values_url" {
  description = "Repository where to get the Helm charts values from"
  type        = string

  validation {
    condition     = length(var.helm_values_url) > 0
    error_message = "helm_values_url cannot be empty."
  }
}

variable "oidc_endpoint" {
  description = "OIDC server endpoint"
  type        = string

  validation {
    condition     = length(var.oidc_endpoint) > 0
    error_message = "oidc_endpoint cannot be empty."
  }
}

variable "oidc_client_id" {
  description = "OIDC client ID"
  type        = string

  validation {
    condition     = length(var.oidc_client_id) > 0
    error_message = "oidc_client_id cannot be empty."
  }
}

variable "oidc_client_secret" {
  description = "OIDC client secret"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.oidc_client_secret) > 0
    error_message = "oidc_client_secret cannot be empty."
  }
}

variable "helm_values_revision" {
  description = "Helm charts values repository revision"
  type        = string

  validation {
    condition     = length(var.helm_values_revision) > 0
    error_message = "helm_values_revision cannot be empty."
  }
}

variable "harbor_domain" {
  description = "Harbor OCI registry domain"
  type        = string

  validation {
    condition     = length(var.harbor_domain) > 0
    error_message = "harbor_domain cannot be empty."
  }
}

variable "helm_registry" {
  description = "Helm chart registry to get the chart from"
  type        = string

  validation {
    condition     = length(var.helm_registry) > 0
    error_message = "helm_registry cannot be empty."
  }
}

variable "argo_deploy_chart_name" {
  description = "Name of the Helm chart holding the ArgoCD AppProject and ApplicationSet"
  type        = string

  validation {
    condition     = length(var.argo_deploy_chart_name) > 0
    error_message = "argo_deploy_chart_name cannot be empty."
  }
}

variable "argo_deploy_chart_version" {
  description = "Version of the Helm chart holding the ArgoCD AppProject and ApplicationSet"
  type        = string

  validation {
    condition     = length(var.argo_deploy_chart_version) > 0
    error_message = "argo_deploy_chart_version cannot be empty."
  }
}

variable "argo_deploy_helm_values" {
  description = "Values for the Helm chart holding the ArgoCD AppProject and ApplicationSet"
  type        = string

  validation {
    condition     = length(var.argo_deploy_helm_values) > 0
    error_message = "argo_deploy_helm_values cannot be empty."
  }
}