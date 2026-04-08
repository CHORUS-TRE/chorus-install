variable "chorusci_namespace" {
  description = "Namespace where ChorusCI is deployed"
  type        = string

  validation {
    condition     = length(var.chorusci_namespace) > 0
    error_message = "chorusci_namespace cannot be empty."
  }
}

variable "github_pat" {
  description = "GitHub Personal Access Token for Argo Workflows"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.github_pat) > 0
    error_message = "github_pat cannot be empty."
  }
}

variable "github_app_private_key" {
  description = "GitHub App private key for Argo Workflows"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.github_app_private_key) > 0
    error_message = "github_app_private_key cannot be empty."
  }
}

variable "github_pat_secret_name" {
  description = "Name of the Kubernetes secret for Argo Workflows GitHub PAT"
  type        = string

  validation {
    condition     = length(var.github_pat_secret_name) > 0
    error_message = "github_pat_secret_name cannot be empty."
  }
}

variable "github_app_secret_name" {
  description = "Name of the Kubernetes secret for Argo Workflows GitHub App"
  type        = string

  validation {
    condition     = length(var.github_app_secret_name) > 0
    error_message = "github_app_secret_name cannot be empty."
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

variable "sensor_regcred_secret_name" {
  description = "The name of the Kubernetes secret for the sensor Docker registry credentials."
  type        = string
  validation {
    condition     = length(var.sensor_regcred_secret_name) > 0
    error_message = "sensor_regcred_secret_name cannot be empty."
  }
}

variable "webhook_events" {
  description = "A map of webhook event names to secret names. Example: { ci = \"ci-secret\", ... }"
  type        = map(string)
  default     = {}
}

variable "webhook_events_map" {
  description = "A map of the webhook event names to their corresponding secret name and secret key."
  type        = map(map(string))
  validation {
    condition     = length(var.webhook_events_map) > 0
    error_message = "webhook_events_map cannot be empty."
  }
}
