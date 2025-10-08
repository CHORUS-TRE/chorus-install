variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where Keycloak and its associated resources will be deployed"

  validation {
    condition     = length(var.namespace) > 0
    error_message = "namespace cannot be empty."
  }
}

variable "secret_name" {
  type        = string
  description = "Name of the Kubernetes Secret that contains the admin credentials for the Keycloak instance."

  validation {
    condition     = length(var.secret_name) > 0
    error_message = "secret_name cannot be empty."
  }
}

variable "secret_key" {
  type        = string
  description = "The key in the Keycloak secret that contains the admin password."

  validation {
    condition     = length(var.secret_key) > 0
    error_message = "secret_key cannot be empty."
  }
}