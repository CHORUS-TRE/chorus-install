variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "cluster_name cannot be empty."
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

variable "argocd_chart_name" {
  description = "ArgoCD Helm chart name"
  type        = string

  validation {
    condition     = length(var.argocd_chart_name) > 0
    error_message = "argocd_chart_name cannot be empty."
  }
}

variable "argocd_chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string

  validation {
    condition     = length(var.argocd_chart_version) > 0
    error_message = "argocd_chart_version cannot be empty."
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

variable "argocd_cache_chart_name" {
  description = "ArgoCD cache (e.g. Valkey) Helm chart name"
  type        = string

  validation {
    condition     = length(var.argocd_cache_chart_name) > 0
    error_message = "argocd_cache_chart_name cannot be empty."
  }
}

variable "argocd_cache_chart_version" {
  description = "ArgoCD cache (e.g. Valkey) Helm chart version"
  type        = string

  validation {
    condition     = length(var.argocd_cache_chart_version) > 0
    error_message = "argocd_cache_chart_version cannot be empty."
  }
}

variable "argocd_cache_helm_values" {
  description = "ArgoCD cache (e.g. Valkey) Helm chart values"
  type        = string

  validation {
    condition     = length(var.argocd_cache_helm_values) > 0
    error_message = "argocd_cache_helm_values cannot be empty."
  }
}

variable "helm_charts_values_credentials_secret" {
  description = "Secret to store the Helm charts values repository credentials in"
  type        = string

  validation {
    condition     = length(var.helm_charts_values_credentials_secret) > 0
    error_message = "helm_charts_values_credentials_secret cannot be empty."
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

variable "helm_values_pat" {
  description = "Fine-grained personal access token (PAT) to access the environments repository (empty for public repositories)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "harbor_domain" {
  description = "Harbor OCI registry domain"
  type        = string

  validation {
    condition     = length(var.harbor_domain) > 0
    error_message = "harbor_domain cannot be empty."
  }
}

variable "harbor_robot_username" {
  description = "Username of the robot used to connect to Harbor"
  type        = string

  validation {
    condition     = length(var.harbor_robot_username) > 0
    error_message = "harbor_robot_username cannot be empty."
  }
}

variable "harbor_robot_password" {
  description = "Password of the robot used to connect to Harbor"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.harbor_robot_password) > 0
    error_message = "harbor_robot_password cannot be empty."
  }
}