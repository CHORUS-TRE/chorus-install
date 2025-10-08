variable "kubeconfig_path" {
  description = "Path to the Kubernetes config file"
  type        = string
}

variable "kubeconfig_context" {
  description = "Kubernetes context to use"
  type        = string
}

variable "helm_values_path" {
  description = "Path to the repository storing the Helm chart values"
  type        = string
  default     = "../values"
}

variable "cert_manager_crds_path" {
  description = "Path to the downloaded Cert-Manager CRDs file"
  type        = string
  default     = "../crds"
}

variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string
  default     = ""
}

variable "argocd_chart_name" {
  description = "ArgoCD Helm chart name"
  type        = string
  default     = "argo-cd"
}

variable "remote_cluster_kubeconfig_path" {
  description = "Path to the Kubernetes config file for the remote cluster"
  type        = string
}

variable "remote_cluster_insecure" {
  description = "Allow insecure connection to remote cluster"
  type        = bool
  default     = false
}

variable "remote_cluster_kubeconfig_context" {
  description = "Kubernetes context to use for the remote cluster"
  type        = string
}

variable "remote_cluster_name" {
  description = "The name of the remote cluster"
  type        = string
  default     = ""
}

variable "remote_cluster_bearer_token" {
  description = "Bearer token for authenticating with the remote Kubernetes cluster"
  type        = string
}

variable "remote_cluster_ca_data" {
  description = "Base64-encoded certificate authority data for the remote Kubernetes cluster"
  type        = string
}

variable "remote_cluster_server" {
  description = "API server endpoint URL of the remote Kubernetes cluster"
  type        = string
}

variable "keycloak_chart_name" {
  description = "Keycloak Helm chart folder name"
  type        = string
  default     = "keycloak"
}

variable "harbor_chart_name" {
  description = "Harbor Helm chart name"
  type        = string
  default     = "harbor"
}

variable "keycloak_infra_realm" {
  description = "Keycloak infrastructure realm name"
  type        = string
  default     = "infra"
}

variable "keycloak_admin_username" {
  description = "Keycloak admin username"
  type        = string
  default     = "admin"
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

variable "backend_chart_name" {
  description = "Chorus backend Helm chart name"
  type        = string
  default     = "backend"
}

variable "kube_prometheus_stack_chart_name" {
  description = "Kube Prometheus stack Helm chart name (i.e. Prometheus, Alertmanager, Grafana)"
  type        = string
  default     = "kube-prometheus-stack"
}

variable "harbor_admin_username" {
  description = "Harbor admin username"
  type        = string
  default     = "admin"
}

variable "templates_path" {
  description = "Path to the templates directory"
  type        = string
  default     = "../templates"
}