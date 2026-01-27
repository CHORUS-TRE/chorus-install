variable "grafana_admin_username" {
  description = "The username of the Grafana admin"
  type        = string

  validation {
    condition     = length(var.grafana_admin_username) > 0
    error_message = "grafana_admin_username cannot be empty."
  }
}

variable "grafana_keycloak_client_secret" {
  description = "Keycloak client secret for Grafana OAuth authentication"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.grafana_keycloak_client_secret) > 0
    error_message = "grafana_keycloak_client_secret cannot be empty."
  }
}

variable "grafana_oauth_client_secret_key" {
  description = "Key within the OAuth secret that stores the client secret"
  type        = string

  validation {
    condition     = length(var.grafana_oauth_client_secret_key) > 0
    error_message = "grafana_oauth_client_secret_key cannot be empty."
  }
}

variable "grafana_oauth_client_secret_name" {
  description = "Name of the Kubernetes Secret containing Grafana OAuth client credentials"
  type        = string

  validation {
    condition     = length(var.grafana_oauth_client_secret_name) > 0
    error_message = "grafana_oauth_client_secret_name cannot be empty."
  }
}

variable "namespace" {
  description = "The Kubernetes namespace where Grafana is deployed"
  type        = string

  validation {
    condition     = length(var.namespace) > 0
    error_message = "namespace cannot be empty."
  }
}
