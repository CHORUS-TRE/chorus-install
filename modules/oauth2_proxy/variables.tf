variable "alertmanager_oauth2_proxy_values" {
  description = "Alertmanager OAUTH2 proxy Helm chart values"
  type        = string
}

variable "prometheus_oauth2_proxy_values" {
  description = "Prometheus OAUTH2 proxy Helm chart values"
  type        = string
}

variable "oauth2_proxy_cache_values" {
  description = "OAuth2 Proxy cache Helm chart values (e.g. Valkey)"
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

variable "oauth2_proxy_cache_namespace" {
  description = "Namespace to deploy the OAuth2 Proxy cache Helm chart into (e.g. Valkey)"
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

variable "alertmanager_keycloak_client_id" {
  description = "Alertmanager client ID used assigned to Prometheus"
  type        = string
}

variable "alertmanager_keycloak_client_secret" {
  description = "Alertmanager client secret used assigned to Prometheus"
  type        = string
  sensitive   = true
}