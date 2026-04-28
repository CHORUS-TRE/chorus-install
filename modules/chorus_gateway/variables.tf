variable "chart_name" {
  description = "Chorus Gateway Helm chart name"
  type        = string

  validation {
    condition     = length(var.chart_name) > 0
    error_message = "chart_name cannot be empty."
  }
}

variable "chart_version" {
  description = "Chorus Gateway Helm chart version"
  type        = string

  validation {
    condition     = length(var.chart_version) > 0
    error_message = "chart_version cannot be empty."
  }
}

variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "cluster_name cannot be empty."
  }
}

variable "gateway_namespace" {
  description = "Namespace where Gateway is deployed (where OIDC secrets will be created)"
  type        = string

  validation {
    condition     = length(var.gateway_namespace) > 0
    error_message = "gateway_namespace cannot be empty."
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

variable "helm_values" {
  description = "Chorus Gateway Helm chart values"
  type        = string

  validation {
    condition     = can(yamldecode(var.helm_values))
    error_message = "helm_values must be valid YAML."
  }
}

variable "kubeconfig_context" {
  description = "Kubernetes context to use"
  type        = string

  validation {
    condition     = length(var.kubeconfig_context) > 0
    error_message = "kubeconfig_context cannot be empty."
  }
}

variable "kubeconfig_path" {
  description = "Path to the Kubernetes config file"
  type        = string

  validation {
    condition     = length(var.kubeconfig_path) > 0
    error_message = "kubeconfig_path cannot be empty."
  }

  validation {
    condition     = fileexists(pathexpand(var.kubeconfig_path))
    error_message = "Kubeconfig file not found at path: ${var.kubeconfig_path}"
  }
}

variable "oidc_client_secrets" {
  description = "Map of OIDC client secrets to create in the gateway namespace. Key is secret name, value is the client secret."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.oidc_client_secrets : length(k) > 0 && length(v) > 0])
    error_message = "All OIDC client secret names and values must be non-empty."
  }
}
