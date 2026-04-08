variable "admin_secret_key" {
  type        = string
  description = "The key in the Keycloak secret that contains the admin password."

  validation {
    condition     = length(var.admin_secret_key) > 0
    error_message = "admin_secret_key cannot be empty."
  }
}

variable "admin_secret_name" {
  type        = string
  description = "Name of the Kubernetes Secret that contains the admin credentials for the Keycloak instance."

  validation {
    condition     = length(var.admin_secret_name) > 0
    error_message = "admin_secret_name cannot be empty."
  }
}

variable "client_credentials_secret_name" {
  type        = string
  description = "Name of the Kubernetes Secret for Keycloak client credentials."
  validation {
    condition     = length(var.client_credentials_secret_name) > 0
    error_message = "client_credentials_secret_name cannot be empty."
  }
}

variable "cluster_type" {
  type        = string
  description = "Cluster type: 'build' or 'remote'. Determines which secrets are created."
  validation {
    condition     = var.cluster_type == "build" || var.cluster_type == "remote"
    error_message = "cluster_type must be either 'build' or 'remote'."
  }
}

variable "google_identity_provider_client_id" {
  type        = string
  description = "Google Identity Provider Client ID for SSO."
  validation {
    condition     = length(var.google_identity_provider_client_id) > 0
    error_message = "google_identity_provider_client_id cannot be empty."
  }
}

variable "google_identity_provider_client_secret" {
  type        = string
  description = "Google Identity Provider Client Secret for SSO."
  sensitive   = true
  validation {
    condition     = length(var.google_identity_provider_client_secret) > 0
    error_message = "google_identity_provider_client_secret cannot be empty."
  }
}

variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where Keycloak and its associated resources will be deployed"

  validation {
    condition     = length(var.namespace) > 0
    error_message = "namespace cannot be empty."
  }
}

variable "remotestate_encryption_key_secret_name" {
  type        = string
  description = "Name of the Kubernetes Secret for the Keycloak remote state encryption key."
  validation {
    condition     = length(var.remotestate_encryption_key_secret_name) > 0
    error_message = "remotestate_encryption_key_secret_name cannot be empty."
  }
}
