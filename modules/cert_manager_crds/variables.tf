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

variable "chart_name" {
  description = "Cert-Manager CRDs Helm chart name"
  type        = string

  validation {
    condition     = length(var.chart_name) > 0
    error_message = "chart_name cannot be empty."
  }
}

variable "chart_version" {
  description = "Cert-Manager CRDs Helm chart version"
  type        = string

  validation {
    condition     = length(var.chart_version) > 0
    error_message = "chart_version cannot be empty."
  }
}

variable "helm_values" {
  description = "Cert-Manager CRDs Helm chart values"
  type        = string

  validation {
    condition     = var.helm_values == "" || can(yamldecode(var.helm_values))
    error_message = "helm_values must be valid YAML or empty."
  }
}

variable "cert_manager_namespace" {
  description = "Namespace where cert-manager will be installed"
  type        = string

  validation {
    condition     = length(var.cert_manager_namespace) > 0
    error_message = "cert_manager_namespace cannot be empty."
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
