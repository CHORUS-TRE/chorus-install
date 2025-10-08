variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where Harbor is deployed"

  validation {
    condition     = length(var.namespace) > 0
    error_message = "namespace cannot be empty."
  }
}

variable "core_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret that contains the core secrets for Harbor"

  validation {
    condition     = length(var.core_secret_name) > 0
    error_message = "core_secret_name cannot be empty."
  }
}

variable "admin_username" {
  type        = string
  description = "The username of the Harbor admin"

  validation {
    condition     = length(var.admin_username) > 0
    error_message = "admin_username cannot be empty."
  }
}

variable "admin_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret that contains the Harbor admin password"

  validation {
    condition     = length(var.admin_secret_name) > 0
    error_message = "admin_secret_name cannot be empty."
  }
}

variable "admin_secret_key" {
  type        = string
  description = "The key in the Harbor admin password secret that stores the actual admin password"

  validation {
    condition     = length(var.admin_secret_key) > 0
    error_message = "admin_secret_key cannot be empty."
  }
}

variable "encryption_key_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret that contains the encryption key"

  validation {
    condition     = length(var.encryption_key_secret_name) > 0
    error_message = "encryption_key_secret_name cannot be empty."
  }
}

variable "xsrf_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret containing the XSRF protection secret for Harbor"

  validation {
    condition     = length(var.xsrf_secret_name) > 0
    error_message = "xsrf_secret_name cannot be empty."
  }
}

variable "xsrf_secret_key" {
  type        = string
  description = "The key in the XSRF protection secret that stores the actual token"

  validation {
    condition     = length(var.xsrf_secret_key) > 0
    error_message = "xsrf_secret_key cannot be empty."
  }
}

variable "jobservice_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret containing the jobservice secret for Harbor's internal communication"

  validation {
    condition     = length(var.jobservice_secret_name) > 0
    error_message = "jobservice_secret_name cannot be empty."
  }
}

variable "jobservice_secret_key" {
  type        = string
  description = "The key in the jobservice secret that stores the actual jobservice secret"

  validation {
    condition     = length(var.jobservice_secret_key) > 0
    error_message = "jobservice_secret_key cannot be empty."
  }
}

variable "registry_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret containing the HTTP secret used by the Harbor registry"

  validation {
    condition     = length(var.registry_secret_name) > 0
    error_message = "registry_secret_name cannot be empty."
  }
}

variable "registry_secret_key" {
  type        = string
  description = "The key within the Harbor registry HTTP secret that holds the shared HTTP secret"

  validation {
    condition     = length(var.registry_secret_key) > 0
    error_message = "registry_secret_key cannot be empty."
  }
}

variable "registry_credentials_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret containing Harbor registry credentials"

  validation {
    condition     = length(var.registry_credentials_secret_name) > 0
    error_message = "registry_credentials_secret_name cannot be empty."
  }
}

variable "oidc_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret containing the OIDC secret for Harbor authentication"

  validation {
    condition     = length(var.oidc_secret_name) > 0
    error_message = "oidc_secret_name cannot be empty."
  }
}

variable "oidc_secret_key" {
  type        = string
  description = "The key in the OIDC secret that contains the OIDC client secret for Harbor authentication"

  validation {
    condition     = length(var.oidc_secret_key) > 0
    error_message = "oidc_secret_key cannot be empty."
  }
}

variable "oidc_config" {
  type        = string
  description = "A string containing the OIDC configuration in JSON format for Harbor integration"

  validation {
    condition     = length(var.oidc_config) > 0
    error_message = "oidc_config cannot be empty."
  }
}