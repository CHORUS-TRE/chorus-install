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

variable "helm_values_pat" {
  description = "Fine-grained personal access token (PAT) to access the Helm chart values repository (e.g. CHORUS-TRE/environment-template)"
  type        = string
  sensitive   = true
  default     = null
}

variable "argocd_chart_name" {
  description = "ArgoCD Helm chart name"
  type        = string
  default     = "argo-cd"
}

variable "argo_workflows_chart_name" {
  description = "Argo Workflows Helm chart name"
  type        = string
  default     = "argo-workflows"
}

variable "argo_deploy_chart_name" {
  description = "Name of the Helm chart holding the CHORUS AppProject and ApplicationSet"
  type        = string
  default     = "argo-deploy"
}

variable "valkey_chart_name" {
  description = "Valkey Helm chart name"
  type        = string
  default     = "valkey"
}

variable "oauth2_proxy_cache_chart_name" {
  description = "OAuth2 Proxy cache Helm chart name"
  type        = string
  default     = "oauth2-proxy-cache"
}

variable "alertmanager_oauth2_proxy_chart_name" {
  description = "Alertmanager OAuth2 Proxy Helm chart name"
  type        = string
  default     = "alertmanager-oauth2-proxy"
}

variable "prometheus_oauth2_proxy_chart_name" {
  description = "Prometheus OAuth2 Proxy Helm chart name"
  type        = string
  default     = "prometheus-oauth2-proxy"
}

variable "harbor_chart_name" {
  description = "Harbor Helm chart name"
  type        = string
  default     = "harbor"
}

variable "kube_prometheus_stack_chart_name" {
  description = "Kube Prometheus stack Helm chart name (i.e. Prometheus, Alertmanager, Grafana)"
  type        = string
  default     = "kube-prometheus-stack"
}

variable "github_orga" {
  description = "GitHub organization to use repositories from"
  type        = string
  default     = "CHORUS-TRE"
}

variable "helm_values_repo" {
  description = "GitHub repository to get the Helm charts values from"
  type        = string
  default     = "environment-template"
}

variable "helm_values_credentials_secret" {
  description = "Secret to store the Helm charts values repository credentials in for ArgoCD"
  type        = string
  default     = "argo-cd-github-environments"
}

variable "github_actions_harbor_robot_username" {
  description = "Harbor robot username used by GitHub Actions"
  type        = string
  default     = "chorus-tre"
}

variable "argocd_harbor_robot_username" {
  description = "Harbor robot username used by ArgoCD"
  type        = string
  default     = "argo-cd"
}

variable "chorusci_chart_name" {
  description = "ChorusCI Helm chart name"
  type        = string
  default     = "chorus-ci"
}

variable "chorusci_harbor_robot_username" {
  description = "Harbor robot username used by ChorusCI"
  type        = string
  default     = "chorus-ci"
}

variable "renovate_harbor_robot_username" {
  description = "Harbor robot username used by Renovate"
  type        = string
  default     = "renovate"
}

variable "keycloak_chart_name" {
  description = "Keycloak Helm chart folder name"
  type        = string
  default     = "keycloak"
}

variable "keycloak_realm" {
  description = "Keycloak realm name"
  type        = string
  default     = "infra"
}

variable "keycloak_admin_username" {
  description = "Keycloak admin username"
  type        = string
  default     = "admin"
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

variable "argo_workflows_keycloak_client_id" {
  description = "Keycloak client ID used assigned to Argo Workflows"
  type        = string
  default     = "argo-workflows"
}

variable "grafana_keycloak_client_id" {
  description = "Keycloak client ID used assigned to Grafana"
  type        = string
  default     = "grafana"
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

variable "harbor_keycloak_oidc_admin_group" {
  description = "Keycloak OIDC admin group assigned to Harbor"
  type        = string
  default     = "HarborAdmins"
}

variable "argocd_keycloak_oidc_admin_group" {
  description = "Keycloak OIDC admin group assigned to ArgoCD"
  type        = string
  default     = "ArgoCDAdmins"
}

variable "argo_workflows_keycloak_oidc_admin_group" {
  description = "Keycloak OIDC admin group assigned to Argo Workflows"
  type        = string
  default     = "ArgoWorkflowsAdmins"
}

variable "grafana_keycloak_oidc_admin_group" {
  description = "Keycloak OIDC admin group assigned to Grafana"
  type        = string
  default     = "Grafana"
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

variable "argo_workflows_keycloak_base_url" {
  description = "Argo Workflows base URL or home URL for the Keycloak auth server to redirect to"
  type        = string
  default     = "/workflows/argo"
}

variable "grafana_keycloak_base_url" {
  description = "Grafana base URL or home URL for the Keycloak auth server to redirect to"
  type        = string
  default     = "/"
}

variable "alertmanager_keycloak_base_url" {
  description = "Alertmanager base URL or home URL for the Keycloak auth server to redirect to"
  type        = string
  default     = "/"
}

variable "prometheus_keycloak_base_url" {
  description = "Prometheus base URL or home URL for the Keycloak auth server to redirect to"
  type        = string
  default     = "/"
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

variable "github_username" {
  description = "GitHub username owner of all the tokens"
  type        = string
}

variable "github_workbench_operator_token" {
  description = "GitHub token for the Workbench Operator repository"
  type        = string
  sensitive   = true
}

variable "github_chorus_web_ui_token" {
  description = "GitHub token for the Chorus Web UI repository"
  type        = string
  sensitive   = true
}

variable "github_images_token" {
  description = "GitHub token for the Images repository"
  type        = string
  sensitive   = true
}

variable "github_chorus_backend_token" {
  description = "GitHub token for the Chorus Backend repository"
  type        = string
  sensitive   = true
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

variable "webex_access_token" {
  description = "The Webex access token for the Alertmanager integration"
  type        = string
  sensitive   = true
  default     = ""
}