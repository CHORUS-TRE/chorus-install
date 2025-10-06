locals {
  cluster_name                = coalesce(var.cluster_name, var.kubeconfig_context)

  config_files = {
    ingress_nginx       = "${var.helm_values_path}/${local.cluster_name}/${var.ingress_nginx_chart_name}/config.json"
    cert_manager        = "${var.helm_values_path}/${local.cluster_name}/${var.cert_manager_chart_name}/config.json"
    selfsigned          = "${var.helm_values_path}/${local.cluster_name}/${var.selfsigned_chart_name}/config.json"
    keycloak            = "${var.helm_values_path}/${local.cluster_name}/${var.keycloak_chart_name}/config.json"
    keycloak_db         = "${var.helm_values_path}/${local.cluster_name}/${var.keycloak_chart_name}-db/config.json"
    harbor              = "${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}/config.json"
    harbor_cache        = "${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}-cache/config.json"
    harbor_db           = "${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}-db/config.json"
  }

  values_files = {
    ingress_nginx = "${var.helm_values_path}/${local.cluster_name}/${var.ingress_nginx_chart_name}/values.yaml"
    cert_manager  = "${var.helm_values_path}/${local.cluster_name}/${var.cert_manager_chart_name}/values.yaml"
    selfsigned    = "${var.helm_values_path}/${local.cluster_name}/${var.selfsigned_chart_name}/values.yaml"
    keycloak      = "${var.helm_values_path}/${local.cluster_name}/${var.keycloak_chart_name}/values.yaml"
    keycloak_db   = "${var.helm_values_path}/${local.cluster_name}/${var.keycloak_chart_name}-db/values.yaml"
    harbor        = "${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}/values.yaml"
    harbor_cache  = "${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}-cache/values.yaml"
    harbor_db     = "${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}-db/values.yaml"
  }

  ingress_nginx_chart_version = jsondecode(file(local.config_files.ingress_nginx)).version
  cert_manager_chart_version  = jsondecode(file(local.config_files.cert_manager)).version
  selfsigned_chart_version    = jsondecode(file(local.config_files.selfsigned)).version
  keycloak_chart_version      = jsondecode(file(local.config_files.keycloak)).version
  keycloak_db_chart_version   = jsondecode(file(local.config_files.keycloak_db)).version
  harbor_chart_version        = jsondecode(file(local.config_files.harbor)).version
  harbor_cache_chart_version  = jsondecode(file(local.config_files.harbor_cache)).version
  harbor_db_chart_version     = jsondecode(file(local.config_files.harbor_db)).version

  ingress_nginx_namespace = jsondecode(file(local.config_files.ingress_nginx)).namespace
  cert_manager_namespace  = jsondecode(file(local.config_files.cert_manager)).namespace
  keycloak_namespace      = jsondecode(file(local.config_files.keycloak)).namespace
  harbor_namespace        = jsondecode(file(local.config_files.harbor)).namespace

  keycloak_values_parsed = yamldecode(file(local.values_files.keycloak))
  keycloak_secret_name   = local.keycloak_values_parsed.keycloak.auth.existingSecret
  keycloak_secret_key    = local.keycloak_values_parsed.keycloak.auth.passwordSecretKey
  keycloak_url           = "https://${local.keycloak_values_parsed.keycloak.ingress.hostname}"

  keycloak_db_values_parsed    = yamldecode(file(local.values_files.keycloak_db))
  keycloak_db_secret_name      = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  keycloak_db_admin_secret_key = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  keycloak_db_user_secret_key  = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey

  harbor_db_values_parsed    = yamldecode(file(local.values_files.harbor_db))
  harbor_db_secret_name      = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  harbor_db_user_secret_key  = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
  harbor_db_admin_secret_key = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey

  harbor_values_parsed                    = yamldecode(file(local.values_files.harbor))
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
  ))
}

# Validate all config files exist
resource "null_resource" "validate_config_files" {
  lifecycle {
    precondition {
      condition = alltrue([for path in values(local.config_files) : can(file(path))])
      error_message = <<-EOT
        Missing configuration files!
        
        ${join("\n        ", [for k, v in local.config_files : "Missing ${k}: ${v}" if !can(file(v))])}
      EOT
    }
  }
}

# Validate all values files exist
resource "null_resource" "validate_values_files" {
  lifecycle {
    precondition {
      condition = alltrue([for path in values(local.values_files) : can(file(path))])
      error_message = <<-EOT
        Missing values files!
        
        ${join("\n        ", [for k, v in local.values_files : "Missing ${k}: ${v}" if !can(file(v))])}
      EOT
    }
  }
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
  helm_values        = file(local.values_files.ingress_nginx)
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
  cert_manager_helm_values   = file(local.values_files.cert_manager)
  cert_manager_namespace     = local.cert_manager_namespace
  cert_manager_crds_path     = var.cert_manager_crds_path

  selfsigned_chart_name    = var.selfsigned_chart_name
  selfsigned_chart_version = local.selfsigned_chart_version
  selfsigned_helm_values   = file(local.values_files.selfsigned)

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
  keycloak_helm_values   = file(local.values_files.keycloak)
  keycloak_namespace     = local.keycloak_namespace
  keycloak_secret_name   = local.keycloak_secret_name
  keycloak_secret_key    = local.keycloak_secret_key

  keycloak_db_chart_name       = var.postgresql_chart_name
  keycloak_db_chart_version    = local.keycloak_db_chart_version
  keycloak_db_helm_values      = file(local.values_files.keycloak_db)
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
  harbor_helm_values    = file(local.values_files.harbor)
  harbor_admin_username = var.harbor_admin_username
  harbor_namespace      = local.harbor_namespace

  harbor_cache_chart_name    = var.valkey_chart_name
  harbor_cache_chart_version = local.harbor_cache_chart_version
  harbor_cache_helm_values   = file(local.values_files.harbor_cache)

  harbor_db_chart_name    = var.postgresql_chart_name
  harbor_db_chart_version = local.harbor_db_chart_version
  harbor_db_helm_values   = file(local.values_files.harbor_db)

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