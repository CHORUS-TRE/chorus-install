# Validate all config files exist
resource "null_resource" "validate_config_files" {
  lifecycle {
    precondition {
      condition     = alltrue([for path in values(local.config_files) : can(file(path))])
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
      condition     = alltrue([for path in values(local.values_files) : can(file(path))])
      error_message = <<-EOT
        Missing values files!
        
        ${join("\n        ", [for k, v in local.values_files : "Missing ${k}: ${v}" if !can(file(v))])}
      EOT
    }
  }
}

# Install charts

module "ingress_nginx" {
  source = "../modules/ingress_nginx"

  cluster_name  = var.cluster_name
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

  cluster_name  = var.cluster_name
  helm_registry = var.helm_registry

  cert_manager_chart_name    = var.cert_manager_chart_name
  cert_manager_chart_version = local.cert_manager_chart_version
  cert_manager_helm_values   = file(local.values_files.cert_manager)
  cert_manager_namespace     = local.cert_manager_namespace
  cert_manager_crds_content  = file(local.cert_manager_crds_path)

  selfsigned_chart_name    = var.selfsigned_chart_name
  selfsigned_chart_version = local.selfsigned_chart_version
  selfsigned_helm_values   = file(local.values_files.selfsigned)

  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
}

module "keycloak" {
  source = "../modules/keycloak"

  cluster_name  = var.cluster_name
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

  cluster_name  = var.cluster_name
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