variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "cluster_name cannot be empty."
  }
}

variable "cluster_type" {
  description = "The type of cluster - determines which set of Keycloak clients to configure"
  type        = string

  validation {
    condition     = var.cluster_type == "build" || var.cluster_type == "remote"
    error_message = "cluster_type must be either 'build' or 'remote'."
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

variable "keycloak_chart_name" {
  description = "Keycloak Helm chart name"
  type        = string

  validation {
    condition     = length(var.keycloak_chart_name) > 0
    error_message = "keycloak_chart_name cannot be empty."
  }
}

variable "keycloak_chart_version" {
  description = "Keycloak Helm chart version"
  type        = string

  validation {
    condition     = length(var.keycloak_chart_version) > 0
    error_message = "keycloak_chart_version cannot be empty."
  }
}

variable "keycloak_helm_values" {
  description = "Keycloak Helm chart values"
  type        = string

  validation {
    condition     = length(var.keycloak_helm_values) > 0
    error_message = "keycloak_helm_values cannot be empty."
  }

  validation {
    condition     = can(yamldecode(var.keycloak_helm_values))
    error_message = "keycloak_helm_values must be valid YAML."
  }
}

variable "keycloak_namespace" {
  description = "Namespace to deploy Keycloak Helm chart into"
  type        = string

  validation {
    condition     = length(var.keycloak_namespace) > 0
    error_message = "keycloak_namespace cannot be empty."
  }
}

variable "keycloak_db_chart_name" {
  description = "Keycloak DB Helm chart name"
  type        = string

  validation {
    condition     = length(var.keycloak_db_chart_name) > 0
    error_message = "keycloak_db_chart_name cannot be empty."
  }
}

variable "keycloak_db_chart_version" {
  description = "Keycloak DB (e.g. PostgreSQL) Helm chart version"
  type        = string

  validation {
    condition     = length(var.keycloak_db_chart_version) > 0
    error_message = "keycloak_db_chart_version cannot be empty."
  }
}

variable "keycloak_db_helm_values" {
  description = "Path to the Keycloak DB (e.g. PostgreSQL) Helm chart values"
  type        = string

  validation {
    condition     = length(var.keycloak_db_helm_values) > 0
    error_message = "keycloak_db_helm_values cannot be empty."
  }

  validation {
    condition     = can(yamldecode(var.keycloak_db_helm_values))
    error_message = "keycloak_db_helm_values must be valid YAML."
  }
}

variable "keycloak_secret_name" {
  description = "Name of the Kubernetes Secret containing Keycloak credentials"
  type        = string

  validation {
    condition     = length(var.keycloak_secret_name) > 0
    error_message = "keycloak_secret_name cannot be empty."
  }
}

variable "keycloak_secret_key" {
  description = "The specific key within the Keycloak secret to retrieve"
  type        = string

  validation {
    condition     = length(var.keycloak_secret_key) > 0
    error_message = "keycloak_secret_key cannot be empty."
  }
}

variable "keycloak_db_secret_name" {
  description = "Name of the Kubernetes Secret containing Keycloak database credentials"
  type        = string

  validation {
    condition     = length(var.keycloak_db_secret_name) > 0
    error_message = "keycloak_db_secret_name cannot be empty."
  }
}

variable "keycloak_db_admin_secret_key" {
  description = "The specific key within the Keycloak database secret to retrieve the admin password"
  type        = string

  validation {
    condition     = length(var.keycloak_db_admin_secret_key) > 0
    error_message = "keycloak_db_admin_secret_key cannot be empty."
  }
}

variable "keycloak_db_user_secret_key" {
  description = "The specific key within the Keycloak database secret to retrieve the user password"
  type        = string

  validation {
    condition     = length(var.keycloak_db_user_secret_key) > 0
    error_message = "keycloak_db_user_secret_key cannot be empty."
  }
}

variable "google_identity_provider_client_id" {
  description = "Google identity provider client ID for Keycloak"
  type        = string

  validation {
    condition     = length(var.google_identity_provider_client_id) > 0
    error_message = "google_identity_provider_client_id cannot be empty."
  }
}

variable "google_identity_provider_client_secret" {
  description = "Google identity provider client secret for Keycloak"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.google_identity_provider_client_secret) > 0
    error_message = "google_identity_provider_client_secret cannot be empty."
  }
}

variable "keycloak_client_credentials_secret_name" {
  description = "Name of the Kubernetes Secret containing Keycloak client credentials"
  type        = string

  validation {
    condition     = length(var.keycloak_client_credentials_secret_name) > 0
    error_message = "keycloak_client_credentials_secret_name cannot be empty."
  }
}

variable "keycloak_remotestate_encryption_key_secret_name" {
  description = "Name of the Kubernetes Secret containing Keycloak remote state encryption key"
  type        = string

  validation {
    condition     = length(var.keycloak_remotestate_encryption_key_secret_name) > 0
    error_message = "keycloak_remotestate_encryption_key_secret_name cannot be empty."
  }
}
