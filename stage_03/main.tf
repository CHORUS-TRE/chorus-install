locals {
  argocd_namespace    = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/config.json")).namespace
  remote_cluster_name = coalesce(var.remote_cluster_name, var.remote_cluster_kubeconfig_context)

  remote_cluster_config = jsonencode({
    bearerToken = var.remote_cluster_bearer_token
    tlsClientConfig = {
      insecure = tobool(var.remote_cluster_insecure)
      caData   = var.remote_cluster_ca_data
    }
  })

  keycloak_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.keycloak_chart_name}/values.yaml")
  keycloak_values_parsed = yamldecode(local.keycloak_values)
  keycloak_namespace     = jsondecode(file("${var.helm_values_path}/${var.remote_cluster_name}/${var.keycloak_chart_name}/config.json")).namespace
  keycloak_secret_name   = local.keycloak_values_parsed.keycloak.auth.existingSecret
  keycloak_secret_key    = local.keycloak_values_parsed.keycloak.auth.passwordSecretKey
  keycloak_url           = "https://${local.keycloak_values_parsed.keycloak.ingress.hostname}"

  keycloak_db_values           = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.keycloak_chart_name}-db/values.yaml")
  keycloak_db_values_parsed    = yamldecode(local.keycloak_db_values)
  keycloak_db_secret_name      = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  keycloak_db_admin_secret_key = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  keycloak_db_user_secret_key  = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey

  harbor_values        = file("${var.helm_values_path}/${var.remote_cluster_name}/${var.harbor_chart_name}/values.yaml")
  harbor_values_parsed = yamldecode(local.harbor_values)
  harbor_namespace     = jsondecode(file("${var.helm_values_path}/${var.remote_cluster_name}/${var.harbor_chart_name}/config.json")).namespace
  harbor_secret_name   = local.harbor_values_parsed.harbor.existingSecretAdminPassword
  harbor_secret_key    = local.harbor_values_parsed.harbor.existingSecretAdminPasswordKey

  harbor_db_values           = file("${var.helm_values_path}/${var.remote_cluster_name}/${var.harbor_chart_name}-db/values.yaml")
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
  harbor_oidc_endpoint    = join("/", [local.keycloak_url, "realms", var.keycloak_realm])

  harbor_oidc_config = <<EOT
  {
  "auth_mode": "oidc_auth",
  "primary_auth_mode": "true",
  "oidc_name": "Keycloak",
  "oidc_endpoint": "${local.harbor_oidc_endpoint}",
  "oidc_client_id": "${var.harbor_keycloak_client_id}",
  "oidc_client_secret": "${random_password.harbor_keycloak_client_secret.result}",
  "oidc_groups_claim": "groups",
  "oidc_admin_group": "${var.harbor_keycloak_oidc_admin_group}",
  "oidc_scope": "openid,profile,offline_access,email,groups",
  "oidc_verify_cert": "false",
  "oidc_auto_onboard": "true",
  "oidc_user_claim": "name"
  }
  EOT
  #TODO: set oidc_verify_cert to "true"
}

provider "kubernetes" {
  alias          = "remote_cluster"
  config_path    = var.remote_cluster_kubeconfig_path
  config_context = var.remote_cluster_kubeconfig_context
}

module "remote_cluster" {
  source = "../modules/remote_cluster"

  cert_manager_crds_path       = "${var.cert_manager_crds_path}/${local.remote_cluster_name}/cert-manager.crds.yaml"
  keycloak_namespace           = local.keycloak_namespace
  keycloak_secret_name         = local.keycloak_secret_name
  keycloak_secret_key          = local.keycloak_secret_key
  keycloak_db_secret_name      = local.keycloak_db_secret_name
  keycloak_db_admin_secret_key = local.keycloak_db_admin_secret_key
  keycloak_db_user_secret_key  = local.keycloak_db_user_secret_key

  harbor_namespace           = local.harbor_namespace
  harbor_secret_name         = local.harbor_secret_name
  harbor_secret_key          = local.harbor_secret_key
  harbor_db_secret_name      = local.harbor_db_secret_name
  harbor_db_admin_secret_key = local.harbor_db_admin_secret_key
  harbor_db_user_secret_key  = local.harbor_db_user_secret_key

  harbor_encryption_key_secret_name       = local.harbor_encryption_key_secret_name
  harbor_xsrf_secret_name                 = local.harbor_xsrf_secret_name
  harbor_xsrf_secret_key                  = local.harbor_xsrf_secret_key
  harbor_admin_secret_name                = local.harbor_admin_secret_name
  harbor_admin_secret_key                 = local.harbor_admin_secret_key
  harbor_jobservice_secret_name           = local.harbor_jobservice_secret_name
  harbor_jobservice_secret_key            = local.harbor_jobservice_secret_key
  harbor_registry_http_secret_name        = local.harbor_registry_http_secret_name
  harbor_registry_http_secret_key         = local.harbor_registry_http_secret_key
  harbor_registry_credentials_secret_name = local.harbor_registry_credentials_secret_name
  harbor_oidc_secret_name                 = local.harbor_oidc_secret_name
  harbor_oidc_secret_key                  = local.harbor_oidc_secret_key
  harbor_oidc_config                      = local.harbor_oidc_config

  providers = {
    kubernetes = kubernetes.remote_cluster
  }
}

# Remote Cluster Connection for ArgoCD running on chorus-build

resource "kubernetes_secret" "remote_clusters" {
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
  depends_on = [module.remote_cluster]
}