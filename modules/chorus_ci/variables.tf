variable "chorusci_namespace" {
  description = "Namespace where ChorusCI is deployed"
  type        = string

  validation {
    condition     = length(var.chorusci_namespace) > 0
    error_message = "chorusci_namespace cannot be empty."
  }
}

variable "chorusci_helm_values" {
  description = "ChorusCI Helm chart values"
  type        = string

  validation {
    condition     = length(var.chorusci_helm_values) > 0
    error_message = "chorusci_helm_values cannot be empty."
  }

  validation {
    condition     = can(yamldecode(var.chorusci_helm_values))
    error_message = "chorusci_helm_values must be valid YAML."
  }
}

variable "github_workbench_operator_token" {
  description = "GitHub token for the Workbench Operator repository"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.github_workbench_operator_token) > 0
    error_message = "github_workbench_operator_token cannot be empty."
  }
}

variable "github_chorus_web_ui_token" {
  description = "GitHub token for the Chorus Web UI repository"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.github_chorus_web_ui_token) > 0
    error_message = "github_chorus_web_ui_token cannot be empty."
  }
}

variable "github_images_token" {
  description = "GitHub token for the Images repository"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.github_images_token) > 0
    error_message = "github_images_token cannot be empty."
  }
}

variable "github_chorus_backend_token" {
  description = "GitHub token for the Chorus Backend repository"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.github_chorus_backend_token) > 0
    error_message = "github_chorus_backend_token cannot be empty."
  }
}

variable "github_username" {
  description = "GitHub username for Argo Workflows to use"
  type        = string

  validation {
    condition     = length(var.github_username) > 0
    error_message = "github_username cannot be empty."
  }
}

variable "registry_server" {
  description = "The container registry server (e.g. Harbor)"
  type        = string

  validation {
    condition     = length(var.registry_server) > 0
    error_message = "registry_server cannot be empty."
  }
}

variable "registry_username" {
  description = "The robot username for the container registry"
  type        = string

  validation {
    condition     = length(var.registry_username) > 0
    error_message = "registry_username cannot be empty."
  }
}

variable "registry_password" {
  description = "The robot password for the container registry"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.registry_password) > 0
    error_message = "registry_password cannot be empty."
  }
}
