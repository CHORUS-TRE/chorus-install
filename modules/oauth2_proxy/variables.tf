variable "alertmanager_oauth2_proxy_values" {
  description = "Alertmanager OAUTH2 proxy Helm chart values"
  type        = string
}

variable "prometheus_oauth2_proxy_values" {
  description = "Prometheus OAUTH2 proxy Helm chart values"
  type        = string
}

variable "valkey_values" {
  description = "Valkey Helm chart values"
  type        = string
}

variable "alertmanager_oauth2_proxy_namespace" {
  description = "Namespace to deploy Alertmanager OAUTH2 poxy Helm chart into"
  type        = string
}

variable "prometheus_oauth2_proxy_namespace" {
  description = "Namespace to deploy Prometheus OAUTH2 poxy Helm chart into"
  type        = string
}

variable "valkey_namespace" {
  description = "Namespace to deploy Valkey Helm chart into"
  type        = string
}

variable "prometheus_keycloak_client_id" {
  description = "Keycloak client ID used assigned to Prometheus"
  type        = string
}

variable "prometheus_keycloak_client_secret" {
  description = "Keycloak client secret used assigned to Prometheus"
  type        = string
  sensitive   = true
}

