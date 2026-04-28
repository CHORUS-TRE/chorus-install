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

module "envoy_gateway" {
  source = "../modules/envoy_gateway"

  cluster_name  = var.cluster_name
  helm_registry = var.helm_registry

  gateway_crds_chart_name    = var.envoy_gateway_crds_chart_name
  gateway_crds_chart_version = local.envoy_gateway_crds_chart_version
  gateway_crds_helm_values   = file(local.values_files.envoy_gateway_crds)

  gateway_chart_name    = var.envoy_gateway_chart_name
  gateway_chart_version = local.envoy_gateway_chart_version
  gateway_helm_values   = file(local.values_files.envoy_gateway)
  gateway_namespace     = local.envoy_gateway_namespace

  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
}

module "cert_manager_crds" {
  source = "../modules/cert_manager_crds"

  cluster_name           = var.cluster_name
  helm_registry          = var.helm_registry
  chart_name             = var.cert_manager_crds_chart_name
  chart_version          = local.cert_manager_crds_chart_version
  helm_values            = file(local.values_files.cert_manager_crds)
  cert_manager_namespace = local.cert_manager_namespace
  kubeconfig_path        = var.kubeconfig_path
  kubeconfig_context     = var.kubeconfig_context
}

module "certificate_authorities" {
  source = "../modules/certificate_authorities"

  cluster_name  = var.cluster_name
  helm_registry = var.helm_registry

  cert_manager_chart_name    = var.cert_manager_chart_name
  cert_manager_chart_version = local.cert_manager_chart_version
  cert_manager_helm_values   = file(local.values_files.cert_manager)
  cert_manager_namespace     = local.cert_manager_namespace

  selfsigned_chart_name    = var.selfsigned_chart_name
  selfsigned_chart_version = local.selfsigned_chart_version
  selfsigned_helm_values   = file(local.values_files.selfsigned)

  cloudflare_api_token = var.cloudflare_api_token

  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context

  depends_on = [
    module.cert_manager_crds,
  ]
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
    module.envoy_gateway,
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
    module.envoy_gateway,
  ]
}

resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = local.prometheus_namespace
  }
}

module "loki" {
  source = "../modules/loki"

  namespace            = local.loki_namespace
  loki_clients         = ["${var.cluster_name}-fluentbit", "${var.cluster_name}-grafana"]
  s3_access_key_id     = var.loki_s3_access_key_id
  s3_secret_access_key = var.loki_s3_secret_access_key

  depends_on = [kubernetes_namespace.prometheus]
}

module "grafana" {
  source = "../modules/grafana"

  namespace                        = local.grafana_namespace
  grafana_admin_username           = var.grafana_admin_username
  grafana_keycloak_client_secret   = module.keycloak.grafana_keycloak_client_secret
  grafana_oauth_client_secret_name = local.grafana_oauth_client_secret_name
  grafana_oauth_client_secret_key  = local.grafana_oauth_client_secret_key
  loki_http_user                   = "${var.cluster_name}-grafana"
  loki_http_password               = module.loki.loki_client_passwords["${var.cluster_name}-grafana"]
  loki_tenant_id                   = var.cluster_name

  depends_on = [
    module.certificate_authorities,
    module.envoy_gateway,
    module.keycloak,
    module.loki,
  ]
}

module "alertmanager" {
  source = "../modules/alertmanager"

  webex_secret_name      = local.alertmanager_webex_secret_name
  webex_secret_key       = local.alertmanager_webex_secret_key
  alertmanager_namespace = local.alertmanager_namespace
  webex_access_token     = var.webex_access_token

  count = var.webex_access_token != "" ? 1 : 0

  depends_on = [module.grafana]
}

module "chorus_gateway" {
  source = "../modules/chorus_gateway"

  cluster_name      = var.cluster_name
  helm_registry     = var.helm_registry
  chart_name        = var.chorus_gateway_chart_name
  chart_version     = local.chorus_gateway_chart_version
  helm_values       = file(local.values_files.chorus_gateway)
  gateway_namespace = local.envoy_gateway_namespace

  oidc_client_secrets = {
    "prometheus-oidc-secret"   = module.keycloak.prometheus_keycloak_client_secret
    "alertmanager-oidc-secret" = module.keycloak.alertmanager_keycloak_client_secret
  }

  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context

  depends_on = [
    module.certificate_authorities,
    module.envoy_gateway,
    module.keycloak,
    module.grafana,
  ]
}

module "fluent_operator" {
  source = "../modules/fluent_operator"

  namespace = local.fluent_operator_namespace

  loki_http_user     = "${var.cluster_name}-fluentbit"
  loki_http_password = module.loki.loki_client_passwords["${var.cluster_name}-fluentbit"]
  loki_tenant_id     = var.cluster_name

  depends_on = [module.loki]
}

module "velero" {
  source = "../modules/velero"

  namespace               = local.velero_namespace
  credentials_secret_name = local.velero_credentials_secret_name
  access_key_id           = var.velero_access_key_id
  secret_access_key       = var.velero_secret_access_key
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
    module.envoy_gateway,
  ]
}

module "chorus_ci" {
  source = "../modules/chorus_ci"

  chorusci_namespace = local.chorusci_namespace

  github_pat             = var.github_pat
  github_app_private_key = var.github_app_private_key
  github_pat_secret_name = "${var.cluster_name}-argo-workflows-github-pat"
  github_app_secret_name = "${var.cluster_name}-argo-workflows-github-app"

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

  helm_charts_values_credentials_secret = "${var.cluster_name}-argocd-repocreds"
  helm_values_url                       = "https://github.com/${var.github_orga}/${var.helm_values_repo}"
  github_app_id                         = var.github_app_id
  github_app_installation_id            = var.github_app_installation_id
  github_app_private_key                = var.github_app_private_key
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

locals {
  output = {
    loadbalancer_ip       = module.envoy_gateway.loadbalancer_ip
    harbor_admin_username = var.harbor_admin_username
    harbor_admin_password = module.harbor.harbor_password
    harbor_url            = local.harbor_url
    harbor_admin_url      = join("/", [local.harbor_url, "account", "sign-in"])

    harbor_chorusci_robot_password = module.harbor.harbor_robot_secrets["chorus-ci"]
    harbor_argocd_robot_password   = module.harbor.harbor_robot_secrets["argo-cd"]
    harbor_renovate_robot_password = module.harbor.harbor_robot_secrets["renovate"]
    harbor_db_username             = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.username
    harbor_db_password             = module.harbor.harbor_db_password
    harbor_db_admin_username       = "postgres"
    harbor_db_admin_password       = module.harbor.harbor_db_admin_password

    keycloak_admin_username    = "admin"
    keycloak_admin_password    = module.keycloak.keycloak_password
    keycloak_url               = local.keycloak_url
    keycloak_db_username       = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.username
    keycloak_db_password       = module.keycloak.keycloak_db_password
    keycloak_db_admin_username = "postgres"
    keycloak_db_admin_password = module.keycloak.keycloak_db_admin_password

    argocd_url      = module.argo_cd.argocd_url
    argocd_username = module.argo_cd.argocd_username
    argocd_password = module.argo_cd.argocd_password
  }
}

resource "local_file" "stage_01_output" {
  filename = "../${var.cluster_name}_output.yaml"
  content  = yamlencode(local.output)
}
