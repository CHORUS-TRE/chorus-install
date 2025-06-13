/*
Do not add Kubernetes/Helm related values in this file.
Instead, build upon the environment-template repository
https://github.com/CHORUS-TRE/environment-template
and reference it using the "helm_values_path" variable below
*/

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

variable "helm_values_pat" {
  description = "Fine-grained personal access token (PAT) to access the environments repository"
  type        = string
  sensitive   = true
}

variable "helm_chart_path" {
  description = "Path to the repository storing the Helm charts"
  type        = string
  default     = "../charts"
}

variable "helm_values_path" {
  description = "Path to the repository storing the Helm chart values"
  type        = string
  default     = "../values"
}

variable "argocd_chart_name" {
  description = "ArgoCD Helm chart folder name"
  type        = string
  default     = "argo-cd"
}

variable "valkey_chart_name" {
  description = "Valkey Helm chart folder name"
  type        = string
  default     = "valkey"
}

variable "harbor_chart_name" {
  description = "Harbor Helm chart folder name"
  type        = string
  default     = "harbor"
}

variable "helm_values_url" {
  description = "Environments repository URL"
  type        = string
  default     = "https://github.com/CHORUS-TRE/environment-template"
}

variable "helm_values_revision" {
  description = "Helm charts values repository revision"
  type        = string
  default     = "HEAD"
}

variable "helm_values_credentials_secret" {
  description = "Secret to store the Helm charts values repository credentials in for ArgoCD"
  type        = string
  default     = "argo-cd-github-environments"
}

variable "argocd_harbor_robot_username" {
  description = "Harbor robot username used by ArgoCD"
  type        = string
  default     = "argo-cd"
}

variable "argoci_harbor_robot_username" {
  description = "Harbor robot username used by ArgoCI"
  type        = string
  default     = "argo-ci"
}

variable "keycloak_chart_name" {
  description = "Keycloak Helm chart folder name"
  type        = string
  default     = "keycloak"
}

variable "keycloak_realm" {
  description = "Keycloak realm name"
  type        = string
  default     = "build"
}

variable "keycloak_admin_username" {
  description = "Keycloak admin username"
  type        = string
}

variable "harbor_keycloak_client_id" {
  description = "Keycloak client ID used assigned to Harbor"
  type        = string
  default     = "harbor"
}

variable "argocd_keycloak_client_id" {
  description = "Keycloak client ID used assigned to ArgoCD"
  type        = string
  default     = "argocd"
}

variable "harbor_keycloak_oidc_admin_group" {
  description = "Keycloak client ID used assigned to Harbor"
  type        = string
  default     = "HarborAdmins"
}

variable "argocd_keycloak_oidc_admin_group" {
  description = "Keycloak client ID used assigned to ArgoCD"
  type        = string
  default     = "ArgoCDAdmins"
}

variable "harbor_keycloak_base_url" {
  description = "Harbor base URL or home URL for the Keycloak auth server to redirect to"
  type        = string
  default     = "/harbor/projects"
}

variable "argocd_keycloak_base_url" {
  description = "ArgoCD base URL or home URL for the Keycloak auth server to redirect to"
  type        = string
  default     = "/applications"
}

variable "harbor_admin_username" {
  description = "Harbor admin username"
  type        = string
}

variable "chorus_charts_revision" {
  description = "Revision of the CHORUS-TRE/chorus-tre repository to get the Helm charts to upload to Harbor"
  type        = string
}