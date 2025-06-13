variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string
}

variable "helm_registry" {
  description = "Helm chart registry to get the chart from"
  type = string
}

variable "keycloak_chart_name" {
  description = "Keycloak Helm chart name"
  type        = string
}

variable "keycloak_chart_version" {
  description = "Keycloak Helm chart version"
  type        = string
}

variable "keycloak_helm_values" {
  description = "Keycloak Helm chart values"
  type        = string
}

variable "keycloak_db_chart_name" {
  description = "Keycloak DB Helm chart name"
  type        = string
}

variable "keycloak_db_chart_version" {
  description = "Keycloak DB (e.g. PostgreSQL) Helm chart version"
  type        = string
}

variable "keycloak_db_helm_values" {
  description = "Path to the Keycloak DB (e.g. PostgreSQL) Helm chart values"
  type        = string
}
