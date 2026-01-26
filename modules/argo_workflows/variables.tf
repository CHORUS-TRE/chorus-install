variable "namespace" {
  description = "The namespace where Argo Workflows will be deployed"
  type        = string
  validation {
    condition     = length(var.namespace) > 0
    error_message = "namespace must not be empty"
  }
}

variable "workflows_namespaces" {
  description = "The namespaces where Argo Workflows will run workflows"
  type        = set(string)
}

variable "keycloak_client_id" {
  description = "The Keycloak client ID for Argo Workflows OIDC authentication"
  type        = string
  validation {
    condition     = length(var.keycloak_client_id) > 0
    error_message = "keycloak_client_id must not be empty"
  }
}

variable "keycloak_client_secret" {
  description = "The Keycloak client secret for Argo Workflows OIDC authentication"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.keycloak_client_secret) > 0
    error_message = "keycloak_client_secret must not be empty"
  }
}

variable "sso_server_client_id_name" {
  description = "The Kubernetes secret name for the Argo Workflows OIDC client ID"
  type        = string
  validation {
    condition     = length(var.sso_server_client_id_name) > 0
    error_message = "sso_server_client_id_name must not be empty"
  }
}

variable "sso_server_client_id_key" {
  description = "The key within the Kubernetes secret for the Argo Workflows OIDC client ID"
  type        = string
  validation {
    condition     = length(var.sso_server_client_id_key) > 0
    error_message = "sso_server_client_id_key must not be empty"
  }
}

variable "sso_server_client_secret_name" {
  description = "The Kubernetes secret name for the Argo Workflows OIDC client secret"
  type        = string
  validation {
    condition     = length(var.sso_server_client_secret_name) > 0
    error_message = "sso_server_client_secret_name must not be empty"
  }
}

variable "sso_server_client_secret_key" {
  description = "The key within the Kubernetes secret for the Argo Workflows OIDC client secret"
  type        = string
  validation {
    condition     = length(var.sso_server_client_secret_key) > 0
    error_message = "sso_server_client_secret_key must not be empty"
  }
}
