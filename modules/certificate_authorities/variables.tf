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

variable "cert_manager_chart_name" {
  description = "Cert-Manager Helm chart name"
  type        = string

  validation {
    condition     = length(var.cert_manager_chart_name) > 0
    error_message = "cert_manager_chart_name cannot be empty."
  }
}

variable "cert_manager_chart_version" {
  description = "Cert-Manager Helm chart version"
  type        = string

  validation {
    condition     = length(var.cert_manager_chart_version) > 0
    error_message = "cert_manager_chart_version cannot be empty."
  }
}

variable "cert_manager_helm_values" {
  description = "Cert-Manager Helm chart values"
  type        = string

  validation {
    condition     = length(var.cert_manager_helm_values) > 0
    error_message = "cert_manager_helm_values cannot be empty."
  }

  validation {
    condition     = can(yamldecode(var.cert_manager_helm_values))
    error_message = "cert_manager_helm_values must be valid YAML."
  }
}

variable "cert_manager_namespace" {
  description = "Namespace to deploy Cert-Manager Helm chart into"
  type        = string

  validation {
    condition     = length(var.cert_manager_namespace) > 0
    error_message = "cert_manager_namespace cannot be empty."
  }
}

variable "selfsigned_chart_name" {
  description = "Self-Signed Issuer Helm chart name"
  type        = string

  validation {
    condition     = length(var.selfsigned_chart_name) > 0
    error_message = "selfsigned_chart_name cannot be empty."
  }
}

variable "selfsigned_chart_version" {
  description = "Self-Signed Issuer Helm chart version"
  type        = string

  validation {
    condition     = length(var.selfsigned_chart_version) > 0
    error_message = "selfsigned_chart_version cannot be empty."
  }
}

variable "selfsigned_helm_values" {
  description = "Self-Signed Issuer Helm chart values"
  type        = string

  validation {
    condition     = length(var.selfsigned_helm_values) > 0
    error_message = "selfsigned_helm_values cannot be empty."
  }

  validation {
    condition     = can(yamldecode(var.selfsigned_helm_values))
    error_message = "selfsigned_helm_values must be valid YAML."
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
    condition     = fileexists(var.kubeconfig_path)
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

variable "cert_manager_crds_content" {
  type        = string
  description = "YAML content of the Cert-Manager CRDs to be applied. Should contain one or more Kubernetes manifests in YAML format."

  validation {
    condition     = can(yamldecode(var.cert_manager_crds_content))
    error_message = "cert_manager_crds_content must be valid YAML."
  }
}