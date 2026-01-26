variable "alertmanager_oauth2_proxy_namespace" {
  description = "Namespace to deploy Alertmanager OAuth2 Proxy Helm chart into"
  type        = string

  validation {
    condition     = length(var.alertmanager_oauth2_proxy_namespace) > 0
    error_message = "alertmanager_oauth2_proxy_namespace cannot be empty."
  }
}

variable "prometheus_oauth2_proxy_namespace" {
  description = "Namespace to deploy Prometheus OAuth2 Proxy Helm chart into"
  type        = string

  validation {
    condition     = length(var.prometheus_oauth2_proxy_namespace) > 0
    error_message = "prometheus_oauth2_proxy_namespace cannot be empty."
  }
}

variable "oauth2_proxy_cache_namespace" {
  description = "Namespace to deploy the OAuth2 Proxy cache Helm chart into (e.g. Valkey)"
  type        = string

  validation {
    condition     = length(var.oauth2_proxy_cache_namespace) > 0
    error_message = "oauth2_proxy_cache_namespace cannot be empty."
  }
}

variable "prometheus_keycloak_client_id" {
  description = "Keycloak client ID assigned to Prometheus"
  type        = string

  validation {
    condition     = length(var.prometheus_keycloak_client_id) > 0
    error_message = "prometheus_keycloak_client_id cannot be empty."
  }
}

variable "prometheus_keycloak_client_secret" {
  description = "Keycloak client secret assigned to Prometheus"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.prometheus_keycloak_client_secret) > 0
    error_message = "prometheus_keycloak_client_secret cannot be empty."
  }
}

variable "alertmanager_keycloak_client_id" {
  description = "Keycloak client ID assigned to Alertmanager"
  type        = string

  validation {
    condition     = length(var.alertmanager_keycloak_client_id) > 0
    error_message = "alertmanager_keycloak_client_id cannot be empty."
  }
}

variable "alertmanager_keycloak_client_secret" {
  description = "Keycloak client secret assigned to Alertmanager"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.alertmanager_keycloak_client_secret) > 0
    error_message = "alertmanager_keycloak_client_secret cannot be empty."
  }
}

variable "alertmanager_session_storage_secret_name" {
  description = "Name of the Kubernetes Secret for Alertmanager OAuth2 Proxy session storage"
  type        = string

  validation {
    condition     = length(var.alertmanager_session_storage_secret_name) > 0
    error_message = "alertmanager_session_storage_secret_name cannot be empty."
  }
}

variable "alertmanager_session_storage_secret_key" {
  description = "Key within the Alertmanager session storage secret"
  type        = string

  validation {
    condition     = length(var.alertmanager_session_storage_secret_key) > 0
    error_message = "alertmanager_session_storage_secret_key cannot be empty."
  }
}

variable "alertmanager_oidc_secret_name" {
  description = "Name of the Kubernetes Secret for Alertmanager OAuth2 Proxy OIDC configuration"
  type        = string

  validation {
    condition     = length(var.alertmanager_oidc_secret_name) > 0
    error_message = "alertmanager_oidc_secret_name cannot be empty."
  }
}

variable "prometheus_session_storage_secret_name" {
  description = "Name of the Kubernetes Secret for Prometheus OAuth2 Proxy session storage"
  type        = string

  validation {
    condition     = length(var.prometheus_session_storage_secret_name) > 0
    error_message = "prometheus_session_storage_secret_name cannot be empty."
  }
}

variable "prometheus_session_storage_secret_key" {
  description = "Key within the Prometheus session storage secret"
  type        = string

  validation {
    condition     = length(var.prometheus_session_storage_secret_key) > 0
    error_message = "prometheus_session_storage_secret_key cannot be empty."
  }
}

variable "prometheus_oidc_secret_name" {
  description = "Name of the Kubernetes Secret for Prometheus OAuth2 Proxy OIDC configuration"
  type        = string

  validation {
    condition     = length(var.prometheus_oidc_secret_name) > 0
    error_message = "prometheus_oidc_secret_name cannot be empty."
  }
}

variable "oauth2_proxy_cache_session_storage_secret_name" {
  description = "Name of the Kubernetes Secret for OAuth2 Proxy cache session storage"
  type        = string

  validation {
    condition     = length(var.oauth2_proxy_cache_session_storage_secret_name) > 0
    error_message = "oauth2_proxy_cache_session_storage_secret_name cannot be empty."
  }
}

variable "oauth2_proxy_cache_session_storage_secret_key" {
  description = "Key within the OAuth2 Proxy cache session storage secret"
  type        = string

  validation {
    condition     = length(var.oauth2_proxy_cache_session_storage_secret_key) > 0
    error_message = "oauth2_proxy_cache_session_storage_secret_key cannot be empty."
  }
}
