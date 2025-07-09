/*
Do not add Kubernetes/Helm related values in this file.
Instead, build upon the environment-template repository
https://github.com/CHORUS-TRE/environment-template
and reference it using the "helm_values_path" variable below
*/

variable "modules_path" {
  description = "Path to the Terraform modules"
  type        = string
  default     = "../modules"
}

variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string
}

variable "kubeconfig_path" {
  description = "Path to the Kubernetes config file"
  type        = string
}

variable "kubeconfig_context" {
  description = "Kubernetes context to use"
  type        = string
}

variable "chorus_release" {
  description = "CHORUS-TRE release to install"
  type        = string
  default     = "v0.1.0-alpha"
}

variable "helm_registry" {
  description = "CHORUS Helm chart registry"
  type        = string
}

variable "helm_registry_username" {
  description = "Username to connect to the CHORUS Helm chart registry"
  type        = string
}

variable "helm_registry_password" {
  description = "Password to connect to the CHORUS Helm chart registry"
  type        = string
  sensitive   = true
}

variable "helm_values_path" {
  description = "Path to the repository storing the Helm chart values"
  type        = string
  default     = "../values"
}

variable "ingress_nginx_chart_name" {
  description = "Ingress-Nginx Helm chart folder name"
  type        = string
  default     = "ingress-nginx"
}

variable "cert_manager_chart_name" {
  description = "Cert-Manager Helm chart folder name"
  type        = string
  default     = "cert-manager"
}

variable "selfsigned_chart_name" {
  description = "Self-Signed Issuer Helm chart folder name"
  type        = string
  default     = "self-signed-issuer"
}

variable "valkey_chart_name" {
  description = "Valkey Helm chart folder name"
  type        = string
  default     = "valkey"
}

variable "keycloak_chart_name" {
  description = "Keycloak Helm chart folder name"
  type        = string
  default     = "keycloak"
}

variable "postgresql_chart_name" {
  description = "PostgreSQL Helm chart folder name"
  type        = string
  default     = "postgresql"
}

variable "harbor_chart_name" {
  description = "Harbor Helm chart folder name"
  type        = string
  default     = "harbor"
}

variable "keycloak_realm" {
  description = "Keycloak realm name"
  type        = string
  default     = "infra"
}

variable "harbor_keycloak_client_id" {
  description = "Keycloak client ID assigned to Harbor"
  type        = string
  default     = "harbor"
}

variable "harbor_keycloak_oidc_admin_group" {
  description = "Keycloak client ID assigned to Harbor"
  type        = string
  default     = "HarborAdmins"
}

variable "harbor_admin_username" {
  description = "Harbor admin username"
  type        = string
  default     = "admin"
}