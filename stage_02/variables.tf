variable "alertmanager_keycloak_client_id" {
  description = "Keycloak client ID used assigned to Alertmanager"
  type        = string
  default     = "alertmanager"
}

variable "alertmanager_oauth2_proxy_chart_name" {
  description = "Alertmanager OAuth2 Proxy Helm chart name"
  type        = string
  default     = "alertmanager-oauth2-proxy"
}

variable "argocd_chart_name" {
  description = "ArgoCD Helm chart name"
  type        = string
  default     = "argo-cd"
}

variable "backend_chart_name" {
  description = "Chorus backend Helm chart name"
  type        = string
  default     = "backend"
}

variable "cert_manager_crds_path" {
  description = "Path to the downloaded Cert-Manager CRDs file"
  type        = string
  default     = "../crds"
}

variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string
}

variable "didata_app_key" {
  description = "DiData app key (base64 encoded)"
  type        = string
  default     = ""
}

variable "didata_chart_name" {
  description = "didata Helm chart name"
  type        = string
  default     = "didata"
}

variable "didata_registry_password" {
  description = "Password used to fetch the DiData image"
  type        = string
  default     = ""
}

variable "didata_registry_username" {
  description = "Username used to fetch the DiData image"
  type        = string
  default     = "didatadevops"
}

variable "frontend_chart_name" {
  description = "Frontend Helm chart name"
  type        = string
  default     = "web-ui"
}

variable "remote_cluster_google_identity_provider_client_id" {
  description = "The Google client identifier"
  type        = string
  default     = ""
}

variable "remote_cluster_google_identity_provider_client_secret" {
  description = "The Google client secret used for authentication"
  type        = string
  sensitive   = true
  default     = ""
}

variable "grafana_admin_username" {
  description = "Grafana admin username"
  type        = string
  default     = "admin"
}

variable "harbor_admin_username" {
  description = "Harbor admin username"
  type        = string
  default     = "admin"
}

variable "harbor_chart_name" {
  description = "Harbor Helm chart name"
  type        = string
  default     = "harbor"
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

variable "helm_values_path" {
  description = "Path to the repository storing the Helm chart values"
  type        = string
  default     = "../values"
}

variable "i2b2_chart_name" {
  description = "i2b2 Helm chart name"
  type        = string
  default     = "i2b2"
}

variable "i2b2_db_password" {
  description = "i2b2 database password"
  type        = string
}

variable "juicefs_chart_name" {
  description = "JuiceFS Helm chart name used as prefix for CSI driver, S3 gateway and cache"
  type        = string
  default     = "juicefs"
}

variable "juicefs_dashboard_username" {
  description = "JuiceFS dashboard username"
  type        = string
  default     = "chorus"
}

variable "keycloak_admin_username" {
  description = "Keycloak admin username"
  type        = string
  default     = "admin"
}

variable "keycloak_chart_name" {
  description = "Keycloak Helm chart folder name"
  type        = string
  default     = "keycloak"
}

variable "keycloak_infra_realm" {
  description = "Keycloak infrastructure realm name"
  type        = string
  default     = "infra"
}

variable "kube_prometheus_stack_chart_name" {
  description = "Kube Prometheus stack Helm chart name (i.e. Prometheus, Alertmanager, Grafana)"
  type        = string
  default     = "kube-prometheus-stack"
}

variable "kubeconfig_context" {
  description = "Kubernetes context to use"
  type        = string
}

variable "kubeconfig_path" {
  description = "Path to the Kubernetes config file"
  type        = string
}

variable "matomo_chart_name" {
  description = "Matomo Helm chart name"
  type        = string
  default     = "matomo"
}

variable "oauth2_proxy_cache_chart_name" {
  description = "OAuth2 proxy cache Helm chart name"
  type        = string
  default     = "oauth2-proxy-cache"
}

variable "prometheus_keycloak_client_id" {
  description = "Keycloak client ID used assigned to Prometheus"
  type        = string
  default     = "prometheus"
}

variable "prometheus_oauth2_proxy_chart_name" {
  description = "Prometheus OAuth2 Proxy Helm chart name"
  type        = string
  default     = "prometheus-oauth2-proxy"
}

variable "reflector_chart_name" {
  description = "Reflector Helm chart name"
  type        = string
  default     = "reflector"
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

variable "remote_cluster_kubeconfig_path" {
  description = "Path to the Kubernetes config file for the remote cluster"
  type        = string
}

variable "remote_cluster_name" {
  description = "The name of the remote cluster"
  type        = string
}

variable "remote_cluster_server" {
  description = "API server endpoint URL of the remote Kubernetes cluster"
  type        = string
}

variable "remote_cluster_webex_access_token" {
  description = "The Webex access token for the Alertmanager integration"
  type        = string
  sensitive   = true
  default     = ""
}

variable "remote_cluster_loki_s3_access_key_id" {
  description = "S3 access key ID for Loki storage in the remote cluster"
  type        = string
  sensitive   = true
}

variable "remote_cluster_loki_s3_secret_access_key" {
  description = "S3 secret access key for Loki storage in the remote cluster"
  type        = string
  sensitive   = true
}

variable "s3_access_key" {
  description = "S3 access key"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 access key"
  type        = string
}

variable "s3_endpoint" {
  description = "S3 endpoint"
  type        = string
}

variable "s3_secret_key" {
  description = "S3 secret key"
  type        = string
  sensitive   = true
}

variable "templates_path" {
  description = "Path to the templates directory"
  type        = string
  default     = "../templates"
}
