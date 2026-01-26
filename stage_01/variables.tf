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

variable "helm_registry" {
  description = "CHORUS Helm chart registry"
  type        = string
}

variable "helm_registry_username" {
  description = "Username to connect to the CHORUS Helm chart registry"
  type        = string
  default     = ""
}

variable "helm_registry_password" {
  description = "Password to connect to the CHORUS Helm chart registry"
  type        = string
  sensitive   = true
  default     = ""
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

variable "cert_manager_crds_folder_name" {
  description = "Name of the folder where the Cert-Manager CRDs file will be downloaded (pattern: folder_name/cluster_name/file_name)"
  type        = string
  default     = "../crds"
}

variable "cert_manager_crds_file_name" {
  description = "Cert-Manager CRDs file name"
  type        = string
  default     = "cert-manager.crds.yaml"
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

variable "grafana_admin_username" {
  description = "Grafana admin username"
  type        = string
  default     = "admin"
}

variable "templates_path" {
  description = "Path to the templates directory"
  type        = string
  default     = "../templates"
}

variable "chorus_priority_class_chart_name" {
  description = "CHORUS Priority Class Helm chart folder name"
  type        = string
  default     = "chorus-priority-class"
}

variable "google_identity_provider_client_id" {
  description = "The Google client identifier"
  type        = string
  default     = ""
}

variable "google_identity_provider_client_secret" {
  description = "The Google client secret used for authentication"
  type        = string
  sensitive   = true
  default     = ""
}

variable "alertmanager_oauth2_proxy_chart_name" {
  description = "Alertmanager OAuth2 Proxy Helm chart folder name"
  type        = string
  default     = "alertmanager-oauth2-proxy"
}

variable "argo_deploy_chart_name" {
  description = "Argo Deploy Helm chart folder name"
  type        = string
  default     = "argo-deploy"
}

variable "argo_workflows_chart_name" {
  description = "Argo Workflows Helm chart folder name"
  type        = string
  default     = "argo-workflows"
}

variable "argocd_chart_name" {
  description = "ArgoCD Helm chart folder name"
  type        = string
  default     = "argo-cd"
}

variable "chorusci_chart_name" {
  description = "Chorus CI Helm chart folder name"
  type        = string
  default     = "chorus-ci"
}

variable "kube_prometheus_stack_chart_name" {
  description = "Kube Prometheus Stack Helm chart folder name"
  type        = string
  default     = "kube-prometheus-stack"
}

variable "oauth2_proxy_cache_chart_name" {
  description = "OAuth2 Proxy Cache Helm chart folder name"
  type        = string
  default     = "oauth2-proxy-cache"
}

variable "prometheus_oauth2_proxy_chart_name" {
  description = "Prometheus OAuth2 Proxy Helm chart folder name"
  type        = string
  default     = "prometheus-oauth2-proxy"
}

variable "webex_access_token" {
  description = "The Webex access token for the Alertmanager integration"
  type        = string
  sensitive   = true
  default     = ""
}

variable "alertmanager_keycloak_client_id" {
  description = "Keycloak client ID used assigned to Alertmanager"
  type        = string
  default     = "alertmanager"
}

variable "prometheus_keycloak_client_id" {
  description = "Keycloak client ID used assigned to Prometheus"
  type        = string
  default     = "prometheus"
}

variable "argo_workflows_keycloak_client_id" {
  description = "Keycloak client ID used assigned to Argo Workflows"
  type        = string
  default     = "argo-workflows"
}

variable "github_username" {
  description = "GitHub username owner of all the tokens"
  type        = string
}

variable "github_workbench_operator_token" {
  description = "GitHub token for the Workbench Operator repository"
  type        = string
  sensitive   = true
}

variable "github_chorus_backend_token" {
  description = "GitHub token for the Chorus Backend repository"
  type        = string
  sensitive   = true
}

variable "github_images_token" {
  description = "GitHub token for the Images repository"
  type        = string
  sensitive   = true
}

variable "github_chorus_web_ui_token" {
  description = "GitHub token for the Chorus Web UI repository"
  type        = string
  sensitive   = true
}