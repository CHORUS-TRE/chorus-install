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

variable "kubeconfig_context" {
  description = "Kubernetes context to use"
  type        = string

  validation {
    condition     = length(var.kubeconfig_context) > 0
    error_message = "kubeconfig_context cannot be empty."
  }
}

variable "gateway_crds_chart_name" {
  description = "Gateway API CRDs Helm chart name"
  type        = string

  validation {
    condition     = length(var.gateway_crds_chart_name) > 0
    error_message = "gateway_crds_chart_name cannot be empty."
  }
}

variable "gateway_crds_chart_version" {
  description = "Gateway API CRDs Helm chart version"
  type        = string

  validation {
    condition     = length(var.gateway_crds_chart_version) > 0
    error_message = "gateway_crds_chart_version cannot be empty."
  }
}

variable "gateway_crds_helm_values" {
  description = "Gateway API CRDs Helm chart values"
  type        = string
  default     = ""

  validation {
    condition     = var.gateway_crds_helm_values == "" || can(yamldecode(var.gateway_crds_helm_values))
    error_message = "gateway_crds_helm_values must be empty or valid YAML."
  }
}

variable "gateway_chart_name" {
  description = "Envoy Gateway Helm chart name"
  type        = string

  validation {
    condition     = length(var.gateway_chart_name) > 0
    error_message = "gateway_chart_name cannot be empty."
  }
}

variable "gateway_chart_version" {
  description = "Envoy Gateway Helm chart version"
  type        = string

  validation {
    condition     = length(var.gateway_chart_version) > 0
    error_message = "gateway_chart_version cannot be empty."
  }
}

variable "gateway_helm_values" {
  description = "Envoy Gateway Helm chart values"
  type        = string

  validation {
    condition     = can(yamldecode(var.gateway_helm_values))
    error_message = "gateway_helm_values must be valid YAML."
  }
}

variable "gateway_namespace" {
  description = "Namespace to deploy Gateway resource into"
  type        = string

  validation {
    condition     = length(var.gateway_namespace) > 0
    error_message = "gateway_namespace cannot be empty."
  }
}
