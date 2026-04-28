variable "alertmanager_keycloak_client_id" {
  description = "Keycloak client ID used assigned to Alertmanager"
  type        = string
  default     = "alertmanager"
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

variable "argo_workflows_keycloak_client_id" {
  description = "Keycloak client ID used assigned to Argo Workflows"
  type        = string
  default     = "argo-workflows"
}

variable "argocd_chart_name" {
  description = "ArgoCD Helm chart folder name"
  type        = string
  default     = "argo-cd"
}

variable "argocd_harbor_robot_username" {
  description = "Harbor robot username used by ArgoCD"
  type        = string
  default     = "argo-cd"
}

variable "argocd_keycloak_client_id" {
  description = "Keycloak client ID used assigned to ArgoCD"
  type        = string
  default     = "argocd"
}

variable "cert_manager_chart_name" {
  description = "Cert-Manager Helm chart folder name"
  type        = string
  default     = "cert-manager"
}

variable "cert_manager_crds_chart_name" {
  description = "Cert-Manager CRDs Helm chart folder name"
  type        = string
  default     = "cert-manager-crds"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token for DNS-01 challenge. If provided, a secret will be created in cert-manager namespace for use in ClusterIssuers. Requires Zone:DNS:Edit permissions for your domain."
  type        = string
  sensitive   = true
  default     = ""

  validation {
    condition     = var.cloudflare_api_token == "" || length(var.cloudflare_api_token) >= 20
    error_message = "Cloudflare API token appears invalid (too short). Expected at least 20 characters."
  }
}

variable "chorus_priority_class_chart_name" {
  description = "CHORUS Priority Class Helm chart folder name"
  type        = string
  default     = "chorus-priority-class"
}

variable "chorusci_chart_name" {
  description = "Chorus CI Helm chart folder name"
  type        = string
  default     = "chorus-ci"
}

variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.cluster_name))
    error_message = "Cluster name must be lowercase alphanumeric with hyphens, start and end with alphanumeric (e.g., 'chorus-build')."
  }
}

variable "fluent_operator_chart_name" {
  description = "Fluent Operator Helm chart folder name"
  type        = string
  default     = "fluent-operator"
}

variable "github_pat" {
  description = "GitHub Personal Access Token for Argo Workflows"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.github_pat) >= 40
    error_message = "GitHub PAT appears invalid (too short). Expected at least 40 characters."
  }
}

variable "github_app_private_key" {
  description = "GitHub App private key for Argo Workflows"
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("-----BEGIN.*PRIVATE KEY-----", var.github_app_private_key))
    error_message = "GitHub App private key must be in PEM format (starting with -----BEGIN ... PRIVATE KEY-----)."
  }
}

variable "github_orga" {
  description = "GitHub organization to use repositories from"
  type        = string
  default     = "CHORUS-TRE"
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
  description = "Harbor Helm chart folder name"
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

variable "helm_registry" {
  description = "CHORUS Helm chart registry"
  type        = string

  validation {
    condition     = var.helm_registry != "" && !can(regex("^https?://", var.helm_registry))
    error_message = "Helm registry must not be empty and must not include the URL scheme (e.g., use 'registry.example.com' not 'https://registry.example.com')."
  }
}

variable "helm_registry_password" {
  description = "Password to connect to the CHORUS Helm chart registry"
  type        = string
  sensitive   = true
  default     = ""
}

variable "helm_registry_username" {
  description = "Username to connect to the CHORUS Helm chart registry"
  type        = string
  default     = ""
}

variable "helm_values_credentials_secret" {
  description = "Secret to store the Helm charts values repository credentials in for ArgoCD"
  type        = string
  default     = "argo-cd-github-environments"
}

variable "helm_values_pat" {
  description = "Fine-grained personal access token (PAT) to access the Helm chart values repository (e.g. CHORUS-TRE/environment-template)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "helm_values_path" {
  description = "Path to the repository storing the Helm chart values"
  type        = string
  default     = "../values"
}

variable "helm_values_repo" {
  description = "GitHub repository to get the Helm charts values from"
  type        = string
  default     = "environment-template"
}

variable "envoy_gateway_chart_name" {
  description = "Envoy gateway Helm chart folder name"
  type        = string
  default     = "gateway-helm"
}

variable "envoy_gateway_crds_chart_name" {
  description = "Envoy gateway CRDs Helm chart folder name"
  type        = string
  default     = "gateway-crds-helm"
}

variable "chorus_gateway_chart_name" {
  description = "Chorus Gateway Helm chart folder name"
  type        = string
  default     = "chorus-gateway"
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

variable "kube_prometheus_stack_chart_name" {
  description = "Kube Prometheus Stack Helm chart folder name"
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

variable "loki_s3_access_key_id" {
  description = "S3 access key ID for Loki storage"
  type        = string
  sensitive   = true
}

variable "loki_s3_secret_access_key" {
  description = "S3 secret access key for Loki storage"
  type        = string
  sensitive   = true
}

variable "loki_chart_name" {
  description = "Loki Helm chart folder name"
  type        = string
  default     = "loki"
}

variable "postgresql_chart_name" {
  description = "PostgreSQL Helm chart folder name"
  type        = string
  default     = "postgresql"
}

variable "prometheus_keycloak_client_id" {
  description = "Keycloak client ID used assigned to Prometheus"
  type        = string
  default     = "prometheus"
}

variable "selfsigned_chart_name" {
  description = "Self-Signed Issuer Helm chart folder name"
  type        = string
  default     = "self-signed-issuer"
}

variable "templates_path" {
  description = "Path to the templates directory"
  type        = string
  default     = "../templates"
}

variable "valkey_chart_name" {
  description = "Valkey Helm chart folder name"
  type        = string
  default     = "valkey"
}

variable "velero_access_key_id" {
  description = "S3 access key ID for Velero backup storage"
  type        = string
  sensitive   = true
}

variable "velero_secret_access_key" {
  description = "S3 secret access key for Velero backup storage"
  type        = string
  sensitive   = true
}

variable "velero_chart_name" {
  description = "Velero Helm chart folder name"
  type        = string
  default     = "velero"
}

variable "webex_access_token" {
  description = "The Webex access token for the Alertmanager integration"
  type        = string
  sensitive   = true
  default     = ""
}
