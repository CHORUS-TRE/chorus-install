variable "alertmanager_oauth2_proxy_values" {
  description = "Alertmanager OAuth2 Proxy Helm chart values"
  type        = string

  validation {
    condition     = length(var.alertmanager_oauth2_proxy_values) > 0
    error_message = "alertmanager_oauth2_proxy_values cannot be empty."
  }

  validation {
    condition     = can(yamldecode(var.alertmanager_oauth2_proxy_values))
    error_message = "alertmanager_oauth2_proxy_values must be valid YAML."
  }
}

variable "prometheus_oauth2_proxy_values" {
  description = "Prometheus OAuth2 Proxy Helm chart values"
  type        = string

  validation {
    condition     = length(var.prometheus_oauth2_proxy_values) > 0
    error_message = "prometheus_oauth2_proxy_values cannot be empty."
  }

  validation {
    condition     = can(yamldecode(var.prometheus_oauth2_proxy_values))
    error_message = "prometheus_oauth2_proxy_values must be valid YAML."
  }
}

variable "oauth2_proxy_cache_values" {
  description = "OAuth2 Proxy cache Helm chart values (e.g. Valkey)"
  type        = string

  validation {
    condition     = length(var.oauth2_proxy_cache_values) > 0
    error_message = "oauth2_proxy_cache_values cannot be empty."
  }

  validation {
    condition     = can(yamldecode(var.oauth2_proxy_cache_values))
    error_message = "oauth2_proxy_cache_values must be valid YAML."
  }
}

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