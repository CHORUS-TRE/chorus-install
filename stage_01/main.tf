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

module "chorus_priority_class" {
  source = "../modules/chorus_priority_class"

  cluster_name       = var.cluster_name
  helm_registry      = var.helm_registry
  chart_name         = var.chorus_priority_class_chart_name
  chart_version      = local.chorus_priority_class_chart_version
  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
}

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
  cluster_type  = "build"
  helm_registry = var.helm_registry

  keycloak_chart_name    = var.keycloak_chart_name
  keycloak_chart_version = local.keycloak_chart_version
  keycloak_helm_values   = file(local.values_files.keycloak)
  keycloak_namespace     = local.keycloak_namespace
  keycloak_secret_name   = local.keycloak_secret_name
  keycloak_secret_key    = local.keycloak_secret_key

  keycloak_client_credentials_secret_name         = local.keycloak_client_credentials_secret_name
  keycloak_remotestate_encryption_key_secret_name = local.keycloak_remotestate_encryption_key_secret_name

  keycloak_db_chart_name       = var.postgresql_chart_name
  keycloak_db_chart_version    = local.keycloak_db_chart_version
  keycloak_db_helm_values      = file(local.values_files.keycloak_db)
  keycloak_db_secret_name      = local.keycloak_db_secret_name
  keycloak_db_admin_secret_key = local.keycloak_db_admin_secret_key
  keycloak_db_user_secret_key  = local.keycloak_db_user_secret_key

  google_identity_provider_client_id     = var.google_identity_provider_client_id
  google_identity_provider_client_secret = var.google_identity_provider_client_secret

  depends_on = [
    module.certificate_authorities,
    module.ingress_nginx,
  ]
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
  harbor_robots           = local.harbor_robots

  depends_on = [
    module.certificate_authorities,
    module.ingress_nginx,
  ]
}

module "grafana" {
  source = "../modules/grafana"

  namespace                        = local.grafana_namespace
  grafana_admin_username           = var.grafana_admin_username
  grafana_keycloak_client_secret   = module.keycloak.grafana_keycloak_client_secret
  grafana_oauth_client_secret_name = local.grafana_oauth_client_secret_name
  grafana_oauth_client_secret_key  = local.grafana_oauth_client_secret_key

  depends_on = [
    module.certificate_authorities,
    module.ingress_nginx,
    module.keycloak,
  ]
}

module "alertmanager" {
  source = "../modules/alertmanager"

  webex_secret_name      = local.alertmanager_webex_secret_name
  webex_secret_key       = local.alertmanager_webex_secret_key
  alertmanager_namespace = local.alertmanager_namespace
  webex_access_token     = var.webex_access_token

  count = var.webex_access_token != "" ? 1 : 0
}

module "oauth2_proxy" {
  source = "../modules/oauth2_proxy"

  alertmanager_oauth2_proxy_namespace = local.alertmanager_oauth2_proxy_namespace
  prometheus_oauth2_proxy_namespace   = local.prometheus_oauth2_proxy_namespace
  oauth2_proxy_cache_namespace        = local.oauth2_proxy_cache_namespace

  prometheus_keycloak_client_id          = var.prometheus_keycloak_client_id
  prometheus_keycloak_client_secret      = module.keycloak.prometheus_keycloak_client_secret
  prometheus_session_storage_secret_name = local.prometheus_session_storage_secret_name
  prometheus_session_storage_secret_key  = local.prometheus_session_storage_secret_key
  prometheus_oidc_secret_name            = local.prometheus_oidc_secret_name

  alertmanager_keycloak_client_id          = var.alertmanager_keycloak_client_id
  alertmanager_keycloak_client_secret      = module.keycloak.alertmanager_keycloak_client_secret
  alertmanager_session_storage_secret_name = local.alertmanager_session_storage_secret_name
  alertmanager_session_storage_secret_key  = local.alertmanager_session_storage_secret_key
  alertmanager_oidc_secret_name            = local.alertmanager_oidc_secret_name

  oauth2_proxy_cache_session_storage_secret_name = local.oauth2_proxy_cache_session_storage_secret_name
  oauth2_proxy_cache_session_storage_secret_key  = local.oauth2_proxy_cache_session_storage_secret_key
}

module "argo_workflows" {
  source = "../modules/argo_workflows"

  namespace                     = local.argo_workflows_namespace
  workflows_namespaces          = local.argo_workflows_workflows_namespaces
  keycloak_client_id            = var.argo_workflows_keycloak_client_id
  keycloak_client_secret        = module.keycloak.argo_workflows_keycloak_client_secret
  sso_server_client_id_name     = local.argo_workflows_sso_server_client_id_name
  sso_server_client_id_key      = local.argo_workflows_sso_server_client_id_key
  sso_server_client_secret_name = local.argo_workflows_sso_server_client_secret_name
  sso_server_client_secret_key  = local.argo_workflows_sso_server_client_secret_key

  depends_on = [
    module.certificate_authorities,
    module.ingress_nginx,
  ]
}

module "chorus_ci" {
  source = "../modules/chorus_ci"

  chorusci_namespace = local.chorusci_namespace

  github_chorus_web_ui_token      = var.github_chorus_web_ui_token
  github_images_token             = var.github_images_token
  github_chorus_backend_token     = var.github_chorus_backend_token
  github_workbench_operator_token = var.github_workbench_operator_token

  github_username = var.github_username

  registry_server   = local.harbor_url
  registry_username = "chorus-ci"
  registry_password = module.harbor.harbor_robot_secrets["chorus-ci"]

  sensor_regcred_secret_name = local.chorusci_sensor_regcred_secret_name
  webhook_events_map         = local.chorusci_webhook_events_map

  depends_on = [module.argo_workflows]
}

module "argo_cd" {
  source = "../modules/argo_cd"

  cluster_name  = var.cluster_name
  helm_registry = var.helm_registry

  argocd_chart_name    = var.argocd_chart_name
  argocd_chart_version = local.argocd_chart_version
  argocd_helm_values   = file(local.values_files.argocd)
  argocd_namespace     = local.argocd_namespace

  argocd_cache_chart_name    = var.valkey_chart_name
  argocd_cache_chart_version = local.argocd_cache_chart_version
  argocd_cache_helm_values   = file(local.values_files.argocd_cache)

  helm_charts_values_credentials_secret = var.helm_values_credentials_secret
  helm_values_url                       = "https://github.com/${var.github_orga}/${var.helm_values_repo}"
  helm_values_pat                       = var.helm_values_pat
  harbor_domain                         = replace(local.harbor_url, "https://", "")
  harbor_robot_username                 = var.argocd_harbor_robot_username
  harbor_robot_password                 = module.harbor.harbor_robot_secrets[var.argocd_harbor_robot_username]
}

resource "helm_release" "argo_deploy" {
  name             = "${var.cluster_name}-${var.argo_deploy_chart_name}"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.argo_deploy_chart_name}"
  version          = local.argo_deploy_chart_version
  namespace        = local.argocd_namespace
  create_namespace = false
  wait             = true
  values           = [file(local.values_files.argo_deploy)]

  depends_on = [module.argo_cd]
}

resource "kubernetes_secret" "argocd_secret" {
  metadata {
    name      = local.argocd_oidc_secret_name
    namespace = local.argocd_namespace
    labels = {
      "app.kubernetes.io/name"    = local.argocd_oidc_secret_name
      "app.kubernetes.io/part-of" = "argocd"
    }
  }

  data = {
    "${local.argocd_keycloak_issuer_key}"        = join("/", [local.keycloak_url, "realms", var.keycloak_realm])
    "${local.argocd_keycloak_client_id_key}"     = var.argocd_keycloak_client_id
    "${local.argocd_keycloak_client_secret_key}" = module.keycloak.argocd_keycloak_client_secret
  }
}
