variable "github_orga" {
  description = "GitHub organization to use repositories from"
  type        = string

  validation {
    condition     = length(var.github_orga) > 0
    error_message = "github_orga cannot be empty."
  }
}

variable "helm_values_repo" {
  description = "The Git repository URL containing Helm values files for deployments"
  type        = string

  validation {
    condition     = length(var.helm_values_repo) > 0
    error_message = "helm_values_repo cannot be empty."
  }
}

variable "helm_values_path" {
  description = "The local file system path where Helm values are stored"
  type        = string

  validation {
    condition     = length(var.helm_values_path) > 0
    error_message = "helm_values_path cannot be empty."
  }
}

variable "helm_values_pat" {
  description = "The Personal Access Token (PAT) used to authenticate with the Helm values Git repository (empty for public repos)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "chorus_release" {
  description = "The Chorus release identifier"
  type        = string

  validation {
    condition     = length(var.chorus_release) > 0
    error_message = "chorus_release cannot be empty."
  }
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster where resources will be deployed"
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "cluster_name cannot be empty."
  }
}

variable "cert_manager_chart_name" {
  description = "The name of the Cert-Manager Helm chart (or wrapper chart) to deploy"
  type        = string

  validation {
    condition     = length(var.cert_manager_chart_name) > 0
    error_message = "cert_manager_chart_name cannot be empty."
  }
}

variable "helm_registry" {
  description = "The OCI registry URL hosting the Helm charts"
  type        = string

  validation {
    condition     = length(var.helm_registry) > 0
    error_message = "helm_registry cannot be empty."
  }
}

variable "helm_registry_username" {
  description = "The username for authenticating with the Helm chart registry (empty for public registries)"
  type        = string
  default     = ""

}

variable "helm_registry_password" {
  description = "The password for authenticating with the Helm chart registry (empty for public registries)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "cert_manager_crds_path" {
  description = "The local file system path to the downloaded Cert-Manager CRDs YAML file"
  type        = string

  validation {
    condition     = length(var.cert_manager_crds_path) > 0
    error_message = "cert_manager_crds_path cannot be empty."
  }
}