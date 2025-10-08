locals {
  cluster_name = coalesce(var.cluster_name, var.kubeconfig_context)

  cert_manager_crds_path = join("/", [var.cert_manager_crds_folder_name, local.cluster_name, var.cert_manager_crds_file_name])

  config_files = {
    ingress_nginx = "${var.helm_values_path}/${local.cluster_name}/${var.ingress_nginx_chart_name}/config.json"
    cert_manager  = "${var.helm_values_path}/${local.cluster_name}/${var.cert_manager_chart_name}/config.json"
    selfsigned    = "${var.helm_values_path}/${local.cluster_name}/${var.selfsigned_chart_name}/config.json"
    keycloak      = "${var.helm_values_path}/${local.cluster_name}/${var.keycloak_chart_name}/config.json"
    keycloak_db   = "${var.helm_values_path}/${local.cluster_name}/${var.keycloak_chart_name}-db/config.json"
    harbor        = "${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}/config.json"
    harbor_cache  = "${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}-cache/config.json"
    harbor_db     = "${var.helm_values_path}/${local.cluster_name}/${var.harbor_chart_name}-db/config.json"
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

  harbor_oidc_config_env = [
    for env in local.harbor_values_parsed.harbor.core.extraEnvVars :
    env if env.name == "CONFIG_OVERWRITE_JSON"
  ][0]
  harbor_oidc_secret_name = local.harbor_oidc_config_env.valueFrom.secretKeyRef.name
  harbor_oidc_secret_key  = local.harbor_oidc_config_env.valueFrom.secretKeyRef.key
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