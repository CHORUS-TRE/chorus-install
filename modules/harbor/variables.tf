variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string
}

variable "helm_registry" {
  description = "Helm chart registry to get the chart from"
  type        = string
}

variable "harbor_chart_name" {
  description = "Harbor Helm chart name"
  type        = string
}

variable "harbor_chart_version" {
  description = "Harbor Helm chart version"
  type        = string
}

variable "harbor_helm_values" {
  description = "Harbor Helm chart values"
  type        = string
}

variable "harbor_namespace" {
  description = "Namespace to deploy Harbor Helm chart into"
  type        = string
}

variable "harbor_cache_chart_name" {
  description = "Harbor cache (e.g. Valkey) Helm chart name"
  type        = string
}

variable "harbor_cache_chart_version" {
  description = "Harbor cache (e.g. Valkey) Helm chart version"
  type        = string
}

variable "harbor_cache_helm_values" {
  description = "Harbor cache (e.g. Valkey) Helm chart values"
  type        = string
}

variable "harbor_db_chart_name" {
  description = "Harbor DB (e.g. PostgreSQL) Helm chart name"
  type        = string
}

variable "harbor_db_chart_version" {
  description = "Harbor DB (e.g. PostgreSQL) Helm chart version"
  type        = string
}

variable "harbor_db_helm_values" {
  description = "Harbor DB Helm chart values (e.g. PostgreSQL)"
  type        = string
}

variable "oidc_endpoint" {
  description = "OIDC server endpoint"
  type        = string
}

variable "oidc_client_id" {
  description = "OIDC client ID"
  type        = string
}

variable "oidc_client_secret" {
  description = "OIDC client secret"
  type        = string
}

variable "oidc_admin_group" {
  description = "OIDC admin group"
  type        = string
}

variable "harbor_admin_username" {
  description = "Harbor admin username"
  type        = string
}