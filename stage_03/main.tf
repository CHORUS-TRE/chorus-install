locals {
  cluster_name        = coalesce(var.cluster_name, var.kubeconfig_context)
  argocd_namespace    = jsondecode(file("${var.helm_values_path}/${local.cluster_name}/${var.argocd_chart_name}/config.json")).namespace
  remote_cluster_name = coalesce(var.remote_cluster_name, var.remote_cluster_kubeconfig_context)

  remote_cluster_config = jsonencode({
    bearerToken = var.remote_cluster_bearer_token
    tlsClientConfig = {
      insecure = tobool(var.remote_cluster_insecure)
      caData   = var.remote_cluster_ca_data
    }
  })

  cert_manager_crds_content = file("${var.cert_manager_crds_path}/${local.remote_cluster_name}/cert-manager.crds.yaml")

  keycloak_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.keycloak_chart_name}/values.yaml")
  keycloak_values_parsed = yamldecode(local.keycloak_values)
  keycloak_namespace     = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.keycloak_chart_name}/config.json")).namespace
  keycloak_secret_name   = local.keycloak_values_parsed.keycloak.auth.existingSecret
  keycloak_secret_key    = local.keycloak_values_parsed.keycloak.auth.passwordSecretKey
  keycloak_url           = "https://${local.keycloak_values_parsed.keycloak.ingress.hostname}"

  keycloak_db_values           = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.keycloak_chart_name}-db/values.yaml")
  keycloak_db_values_parsed    = yamldecode(local.keycloak_db_values)
  keycloak_db_secret_name      = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  keycloak_db_admin_secret_key = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  keycloak_db_user_secret_key  = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey

  harbor_values           = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.harbor_chart_name}/values.yaml")
  harbor_values_parsed    = yamldecode(local.harbor_values)
  harbor_namespace        = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.harbor_chart_name}/config.json")).namespace
  harbor_core_secret_name = local.harbor_values_parsed.harbor.core.existingSecret
  harbor_url              = local.harbor_values_parsed.harbor.externalURL

  harbor_db_values           = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.harbor_chart_name}-db/values.yaml")
  harbor_db_values_parsed    = yamldecode(local.harbor_db_values)
  harbor_db_secret_name      = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  harbor_db_admin_secret_key = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  harbor_db_user_secret_key  = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey

  harbor_encryption_key_secret_name       = local.harbor_values_parsed.harbor.existingSecretSecretKey
  harbor_xsrf_secret_name                 = local.harbor_values_parsed.harbor.core.existingXsrfSecret
  harbor_xsrf_secret_key                  = local.harbor_values_parsed.harbor.core.existingXsrfSecretKey
  harbor_admin_secret_name                = local.harbor_values_parsed.harbor.existingSecretAdminPassword
  harbor_admin_secret_key                 = local.harbor_values_parsed.harbor.existingSecretAdminPasswordKey
  harbor_jobservice_secret_name           = local.harbor_values_parsed.harbor.jobservice.existingSecret
  harbor_jobservice_secret_key            = local.harbor_values_parsed.harbor.jobservice.existingSecretKey
  harbor_registry_http_secret_name        = local.harbor_values_parsed.harbor.registry.existingSecret
  harbor_registry_http_secret_key         = local.harbor_values_parsed.harbor.registry.existingSecretKey
  harbor_registry_credentials_secret_name = local.harbor_values_parsed.harbor.registry.credentials.existingSecret

  harbor_oidc_secret = local.harbor_values_parsed.harbor.core.extraEnvVars[
    index(
      local.harbor_values_parsed.harbor.core.extraEnvVars[*].name,
      "CONFIG_OVERWRITE_JSON"
    )
  ].valueFrom.secretKeyRef
  harbor_oidc_secret_name = local.harbor_oidc_secret.name
  harbor_oidc_secret_key  = local.harbor_oidc_secret.key
  harbor_oidc_endpoint    = join("/", [local.keycloak_url, "realms", var.keycloak_infra_realm])

  harbor_oidc_config = jsondecode(templatefile("${var.templates_path}/harbor_oidc.tmpl",
    {
      oidc_endpoint      = local.harbor_oidc_endpoint
      oidc_client_id     = var.harbor_keycloak_client_id
      oidc_client_secret = random_password.harbor_keycloak_client_secret.result
      oidc_admin_group   = var.harbor_keycloak_oidc_admin_group
    }
  )) #TODO: set oidc_verify_cert to "true"

  kube_prometheus_stack_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.kube_prometheus_stack_chart_name}/values.yaml")
  kube_prometheus_stack_values_parsed = yamldecode(local.kube_prometheus_stack_values)
  grafana_url                         = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana["grafana.ini"].server.root_url

  alertmanager_oauth2_proxy_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/values.yaml")
  alertmanager_oauth2_proxy_values_parsed = yamldecode(local.alertmanager_oauth2_proxy_values)
  alertmanager_url                        = "https://${local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"

  prometheus_oauth2_proxy_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/values.yaml")
  prometheus_oauth2_proxy_values_parsed = yamldecode(local.prometheus_oauth2_proxy_values)
  prometheus_url                        = "https://${local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"

  backend_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.backend_chart_name}/values.yaml")
  backend_values_parsed = yamldecode(local.backend_values)
  backend_url           = "https://${local.backend_values_parsed.ingress.host}"
}

# Providers

provider "kubernetes" {
  alias          = "build_cluster"
  config_path    = var.kubeconfig_path
  config_context = var.kubeconfig_context
}

# Random passwords

resource "random_password" "harbor_keycloak_client_secret" {
  length  = 32
  special = false
}

# Cert-Manager CRDs

module "cert_manager_crds" {
  source = "../modules/cert_manager_crds"

  cert_manager_crds_content = local.cert_manager_crds_content
}

# Keycloak

resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = local.keycloak_namespace
  }
}

module "keycloak_db_secret" {
  source = "../modules/db_secret"

  namespace           = local.keycloak_namespace
  secret_name         = local.keycloak_db_secret_name
  db_user_secret_key  = local.keycloak_db_user_secret_key
  db_admin_secret_key = local.keycloak_db_admin_secret_key

  depends_on = [kubernetes_namespace.keycloak]
}

module "keycloak_secret" {
  source = "../modules/keycloak_secret"

  namespace   = local.keycloak_namespace
  secret_name = local.keycloak_secret_name
  secret_key  = local.keycloak_secret_key

  depends_on = [kubernetes_namespace.keycloak]
}

# Harbor

resource "kubernetes_namespace" "harbor" {
  metadata {
    name = local.harbor_namespace
  }
}

module "harbor_db_secret" {
  source = "../modules/db_secret"

  namespace           = local.harbor_namespace
  secret_name         = local.harbor_db_secret_name
  db_user_secret_key  = local.harbor_db_user_secret_key
  db_admin_secret_key = local.harbor_db_admin_secret_key

  depends_on = [kubernetes_namespace.harbor]
}

module "harbor_secret" {
  source = "../modules/harbor_secret"

  namespace                        = local.harbor_namespace
  core_secret_name                 = local.harbor_core_secret_name
  encryption_key_secret_name       = local.harbor_encryption_key_secret_name
  xsrf_secret_name                 = local.harbor_xsrf_secret_name
  xsrf_secret_key                  = local.harbor_xsrf_secret_key
  admin_secret_name                = local.harbor_admin_secret_name
  admin_secret_key                 = local.harbor_admin_secret_key
  jobservice_secret_name           = local.harbor_jobservice_secret_name
  jobservice_secret_key            = local.harbor_jobservice_secret_key
  registry_secret_name             = local.harbor_registry_http_secret_name
  registry_secret_key              = local.harbor_registry_http_secret_key
  registry_credentials_secret_name = local.harbor_registry_credentials_secret_name
  oidc_secret_name                 = local.harbor_oidc_secret_name
  oidc_secret_key                  = local.harbor_oidc_secret_key
  oidc_config                      = jsonencode(local.harbor_oidc_config)

  depends_on = [kubernetes_namespace.harbor]
}

# Remote Cluster Connection for ArgoCD running on chorus-build

resource "kubernetes_secret" "remote_clusters" {
  provider = kubernetes.build_cluster

  metadata {
    name      = "${local.remote_cluster_name}-cluster"
    namespace = local.argocd_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }

  data = {
    name   = local.remote_cluster_name
    server = var.remote_cluster_server
    config = local.remote_cluster_config
  }

  # We wait for the remote cluster configuration
  # to complete to avoir race condition on
  # namespace creation
  depends_on = [
    module.harbor_db_secret,
    module.harbor_secret,
    module.keycloak_db_secret,
    module.keycloak_secret
  ]
}