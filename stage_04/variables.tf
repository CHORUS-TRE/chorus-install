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
  description = "The build cluster name"
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
  type        = string
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

variable "keycloak_backend_realm" {
  description = "Keycloak chorus backend realm name"
  type        = string
  default     = "chorus"
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

variable "harbor_keycloak_base_url" {
  description = "Harbor base URL or home URL for the Keycloak auth server to redirect to"
  type        = string
  default     = "/harbor/projects"
}

variable "grafana_keycloak_client_id" {
  description = "Keycloak client ID assigned to Grafana"
  type        = string
  default     = "grafana"
}

variable "grafana_keycloak_base_url" {
  description = "Grafana base URL or home URL for the Keycloak auth server to redirect to"
  type        = string
  default     = "/"
}

variable "grafana_keycloak_oidc_admin_group" {
  description = "Keycloak OIDC admin group assigned to Grafana"
  type        = string
  default     = "Grafana"
}

variable "alertmanager_keycloak_client_id" {
  description = "Keycloak client ID assigned to Alertmanager"
  type        = string
  default     = "alertmanager"
}

variable "alertmanager_oauth2_proxy_chart_name" {
  description = "Alertmanager OAuth2 Proxy Helm chart name"
  type        = string
  default     = "alertmanager-oauth2-proxy"
}

variable "alertmanager_keycloak_base_url" {
  description = "Alertmanager base URL or home URL for the Keycloak auth server to redirect to"
  type        = string
  default     = "/"
}

variable "prometheus_keycloak_client_id" {
  description = "Keycloak client ID assigned to Prometheus"
  type        = string
  default     = "prometheus"
}

variable "prometheus_oauth2_proxy_chart_name" {
  description = "Prometheus OAuth2 Proxy Helm chart name"
  type        = string
  default     = "prometheus-oauth2-proxy"
}

variable "prometheus_keycloak_base_url" {
  description = "Prometheus base URL or home URL for the Keycloak auth server to redirect to"
  type        = string
  default     = "/"
}

variable "backend_keycloak_client_id" {
  description = "Keycloak client ID assigned to Prometheus"
  type        = string
  default     = "chorus"
}

variable "backend_keycloak_base_url" {
  description = "Chorus backend base URL or home URL for the Keycloak auth server to redirect to"
  type        = string
  default     = "/"
}

variable "backend_chart_name" {
  description = "Chorus backend Helm chart name"
  type        = string
  default     = "backend"
}

variable "matomo_keycloak_client_id" {
  description = "Keycloak client ID assigned to Matomo"
  type        = string
  default     = "matomo"
}

variable "matomo_keycloak_base_url" {
  description = "Matomo base URL or home URL for the Keycloak auth server to redirect to"
  type        = string
  default     = "/"
}

variable "matomo_chart_name" {
  description = "Matomo Helm chart name"
  type        = string
  default     = "matomo"
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

variable "oauth2_proxy_cache_chart_name" {
  description = "OAuth2 proxy cache Helm chart name"
  type        = string
  default     = "oauth2-proxy-cache"
}

variable "grafana_admin_username" {
  description = "Grafana admin username"
  type        = string
  default     = "admin"
}

variable "i2b2_chart_name" {
  description = "i2b2 Helm chart name"
  type        = string
  default     = "i2b2"
}

variable "didata_chart_name" {
  description = "didata Helm chart name"
  type        = string
  default     = "didata"
}

variable "didata_app_key" {
  description = "DiData app key (base64 encoded)"
  type        = string
  default     = ""
}

variable "didata_registry_username" {
  description = "Username used to fetch the DiData image"
  type        = string
  default     = "didatadevops"
}

variable "didata_registry_password" {
  description = "Password used to fetch the DiData image"
  type        = string
  default     = ""
}

variable "templates_path" {
  description = "Path to the templates directory"
  type        = string
  default     = "../templates"
}

variable "frontend_chart_name" {
  description = "Frontend Helm chart name"
  type        = string
  default     = "web-ui"
}

variable "i2b2_db_password" {
  description = "i2b2 database password"
  type        = string
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

variable "remote_cluster_webex_access_token" {
  description = "The Webex access token for the Alertmanager integration"
  type        = string
  sensitive   = true
  default     = ""
}

variable "juicefs_csi_driver_chart_name" {
  description = "JuiceFS CSI driver Helm chart name"
  type        = string
  default     = "juicefs-csi-driver"
}

variable "juicefs_s3_gateway_chart_name" {
  description = "JuiceFS S3 gateway Helm chart name"
  type        = string
  default     = "juicefs-s3-gateway"
}

variable "juicefs_dashboard_username" {
  description = "JuiceFS dashboard username"
  type        = string
  default     = "chorus"
}

variable "s3_bucket_name" {
  description = "S3 access key"
  type        = string
  default     = ""
}

variable "s3_endpoint" {
  description = "S3 endpoint"
  type        = string
  default     = ""
}

variable "s3_access_key" {
  description = "S3 access key"
  type        = string
  default     = ""
}

variable "s3_secret_key" {
  description = "S3 secret key"
  type        = string
  sensitive   = true
  default     = ""
}
