locals {
  cluster_name                = coalesce(var.cluster_name, var.kubeconfig_context)
  ingress_nginx_chart_version = jsondecode(file("${var.helm_values_path}/${local.cluster_name}/${var.ingress_nginx_chart_name}/config.json")).version
  cert_manager_chart_version  = jsondecode(file("${var.helm_values_path}/${local.cluster_name}/${var.cert_manager_chart_name}/config.json")).version
  selfsigned_chart_version    = jsondecode(file("${var.helm_values_path}/${local.cluster_name}/${var.selfsigned_chart_name}/config.json")).version
  keycloak_chart_version      = jsondecode(file("${var.helm_values_path}/${local.cluster_name}/${var.keycloak_chart_name}/config.json")).version
  keycloak_db_chart_version   = jsondecode(file("${var.helm_values_path}/${local.cluster_name}/${var.keycloak_chart_name}-db/config.json")).version
  harbor_chart_version        = jsondecode(file("${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}/config.json")).version
  harbor_cache_chart_version  = jsondecode(file("${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}-cache/config.json")).version
  harbor_db_chart_version     = jsondecode(file("${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}-db/config.json")).version

  ingress_nginx_namespace = jsondecode(file("${var.helm_values_path}/${local.cluster_name}/${var.ingress_nginx_chart_name}/config.json")).namespace
  cert_manager_namespace  = jsondecode(file("${var.helm_values_path}/${local.cluster_name}/${var.cert_manager_chart_name}/config.json")).namespace
  keycloak_namespace      = jsondecode(file("${var.helm_values_path}/${local.cluster_name}/${var.keycloak_chart_name}/config.json")).namespace
  harbor_namespace        = jsondecode(file("${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}/config.json")).namespace

  keycloak_helm_values   = file("${var.helm_values_path}/${local.cluster_name}/${var.keycloak_chart_name}/values.yaml")
  keycloak_values_parsed = yamldecode(local.keycloak_helm_values)
  keycloak_secret_name   = local.keycloak_values_parsed.keycloak.auth.existingSecret
  keycloak_secret_key    = local.keycloak_values_parsed.keycloak.auth.passwordSecretKey
  keycloak_url           = "https://${local.keycloak_values_parsed.keycloak.ingress.hostname}"

  keycloak_db_helm_values      = file("${var.helm_values_path}/${local.cluster_name}/${var.keycloak_chart_name}-db/values.yaml")
  keycloak_db_values_parsed    = yamldecode(local.keycloak_db_helm_values)
  keycloak_db_secret_name      = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  keycloak_db_admin_secret_key = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  keycloak_db_user_secret_key  = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey

  harbor_helm_values       = file("${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}/values.yaml")
  harbor_cache_helm_values = file("${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}-cache/values.yaml")
  harbor_db_helm_values    = file("${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}-db/values.yaml")

  harbor_db_values_parsed    = yamldecode(local.harbor_db_helm_values)
  harbor_db_secret_name      = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  harbor_db_user_secret_key  = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
  harbor_db_admin_secret_key = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey

  harbor_values_parsed                    = yamldecode(local.harbor_helm_values)
  harbor_core_secret_name                 = local.harbor_values_parsed.harbor.core.existingSecret
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

  harbor_oidc_config = jsondecode(templatefile("${var.templates_path}/harbor_oidc.tmpl",
    {
      oidc_endpoint      = local.harbor_oidc_endpoint
      oidc_client_id     = var.harbor_keycloak_client_id
      oidc_client_secret = random_password.harbor_keycloak_client_secret.result
      oidc_admin_group   = var.harbor_keycloak_oidc_admin_group
    }
  )) #TODO: set oidc_verify_cert to "true"
}

# Install charts

provider "helm" {
  alias = "chorus_helm"

  kubernetes {
    config_path    = var.kubeconfig_path
    config_context = var.kubeconfig_context
  }

  registry {
    url      = "oci://${var.helm_registry}"
    username = var.helm_registry_username
    password = var.helm_registry_password
  }
}

module "ingress_nginx" {
  source = "../modules/ingress_nginx"

  providers = {
    helm = helm.chorus_helm
  }

  cluster_name  = local.cluster_name
  helm_registry = var.helm_registry

  chart_name         = var.ingress_nginx_chart_name
  chart_version      = local.ingress_nginx_chart_version
  helm_values        = file("${var.helm_values_path}/${local.cluster_name}/${var.ingress_nginx_chart_name}/values.yaml")
  namespace          = local.ingress_nginx_namespace
  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
}

module "certificate_authorities" {
  source = "../modules/certificate_authorities"

  providers = {
    helm = helm.chorus_helm
  }

  cluster_name  = local.cluster_name
  helm_registry = var.helm_registry

  cert_manager_chart_name    = var.cert_manager_chart_name
  cert_manager_chart_version = local.cert_manager_chart_version
  cert_manager_helm_values   = file("${var.helm_values_path}/${local.cluster_name}/${var.cert_manager_chart_name}/values.yaml")
  cert_manager_namespace     = local.cert_manager_namespace
  cert_manager_crds_path     = var.cert_manager_crds_path

  selfsigned_chart_name    = var.selfsigned_chart_name
  selfsigned_chart_version = local.selfsigned_chart_version
  selfsigned_helm_values   = file("${var.helm_values_path}/${local.cluster_name}/${var.selfsigned_chart_name}/values.yaml")

  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
}

module "keycloak" {
  source = "../modules/keycloak"

  providers = {
    helm = helm.chorus_helm
  }

  cluster_name  = local.cluster_name
  helm_registry = var.helm_registry

  keycloak_chart_name    = var.keycloak_chart_name
  keycloak_chart_version = local.keycloak_chart_version
  keycloak_helm_values   = local.keycloak_helm_values
  keycloak_namespace     = local.keycloak_namespace
  keycloak_secret_name   = local.keycloak_secret_name
  keycloak_secret_key    = local.keycloak_secret_key

  keycloak_db_chart_name       = var.postgresql_chart_name
  keycloak_db_chart_version    = local.keycloak_db_chart_version
  keycloak_db_helm_values      = local.keycloak_db_helm_values
  keycloak_db_secret_name      = local.keycloak_db_secret_name
  keycloak_db_admin_secret_key = local.keycloak_db_admin_secret_key
  keycloak_db_user_secret_key  = local.keycloak_db_user_secret_key

  depends_on = [
    module.certificate_authorities,
    module.ingress_nginx,
  ]
}

resource "random_password" "harbor_keycloak_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "argocd_keycloak_client_secret" {
  length  = 32
  special = false
}

module "harbor" {
  source = "../modules/harbor"

  cluster_name  = local.cluster_name
  helm_registry = var.helm_registry

  harbor_chart_name     = var.harbor_chart_name
  harbor_chart_version  = local.harbor_chart_version
  harbor_helm_values    = local.harbor_helm_values
  harbor_admin_username = var.harbor_admin_username
  harbor_namespace      = local.harbor_namespace

  harbor_cache_chart_name    = var.valkey_chart_name
  harbor_cache_chart_version = local.harbor_cache_chart_version
  harbor_cache_helm_values   = local.harbor_cache_helm_values

  harbor_db_chart_name    = var.postgresql_chart_name
  harbor_db_chart_version = local.harbor_db_chart_version
  harbor_db_helm_values   = local.harbor_db_helm_values

  harbor_db_secret_name                   = local.harbor_db_secret_name
  harbor_db_user_secret_key               = local.harbor_db_user_secret_key
  harbor_db_admin_secret_key              = local.harbor_db_admin_secret_key
  harbor_core_secret_name                 = local.harbor_core_secret_name
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

  harbor_oidc_secret_name = local.harbor_oidc_secret_name
  harbor_oidc_secret_key  = local.harbor_oidc_secret_key
  harbor_oidc_config      = jsonencode(local.harbor_oidc_config)

  depends_on = [
    module.certificate_authorities,
    module.ingress_nginx,
  ]
}