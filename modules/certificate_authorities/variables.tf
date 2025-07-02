variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string
}

variable "helm_registry" {
  description = "Helm chart registry to get the chart from"
  type        = string
}

variable "cert_manager_chart_name" {
  description = "Cert-Manager Helm chart name"
  type        = string
}

variable "cert_manager_chart_version" {
  description = "Cert-Manager Helm chart version"
  type        = string
}

variable "cert_manager_app_version" {
  description = "Cert-Manager version"
  type        = string
}

variable "cert_manager_helm_values" {
  description = "Cert-Manager Helm chart values"
  type        = string
}

variable "cert_manager_namespace" {
  description = "Namespace to deploy Cert-Manager Helm chart into"
  type        = string
}

variable "selfsigned_chart_name" {
  description = "Self-Signed Issuer Helm chart name"
  type        = string
}

variable "selfsigned_chart_version" {
  description = "Self-Signed Issuer Helm chart version"
  type        = string
}

variable "selfsigned_helm_values" {
  description = "Self-Signed Issuer Helm chart values"
  type        = string
}