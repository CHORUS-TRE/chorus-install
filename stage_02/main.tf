locals {
  helm_values_folders = toset([for x in fileset("${path.module}/${var.helm_values_path}/${var.cluster_name}", "**") : dirname(x)])
  charts_versions     = { for x in local.helm_values_folders : jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${x}/config.json")).chart => jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${x}/config.json")).version... }

  argo_deploy_chart_version = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.argo_deploy_chart_name}/config.json")).version

  argocd_chart_version       = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/config.json")).version
  argocd_cache_chart_version = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}-cache/config.json")).version
  argocd_namespace           = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/config.json")).namespace
  chorusci_namespace         = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.chorusci_chart_name}/config.json")).namespace

  harbor_values                             = file("${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}/values.yaml")
  harbor_values_parsed                      = yamldecode(local.harbor_values)
  harbor_namespace                          = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}/config.json")).namespace
  harbor_existing_admin_password_secret     = local.harbor_values_parsed.harbor.existingSecretAdminPassword
  harbor_existing_admin_password_secret_key = local.harbor_values_parsed.harbor.existingSecretAdminPasswordKey
  harbor_admin_password                     = data.kubernetes_secret.harbor_existing_admin_password.data["${local.harbor_existing_admin_password_secret_key}"]
  harbor_url                                = local.harbor_values_parsed.harbor.externalURL
  harbor_existing_oidc_secret               = local.harbor_values_parsed.harbor.core.extraEnvVars.0.valueFrom.secretKeyRef.name
  harbor_existing_oidc_secret_key           = local.harbor_values_parsed.harbor.core.extraEnvVars.0.valueFrom.secretKeyRef.key
  harbor_keycloak_client_secret             = jsondecode(data.kubernetes_secret.harbor_oidc.data["${local.harbor_existing_oidc_secret_key}"]).oidc_client_secret
  harbor_db_values                          = file("${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}-db/values.yaml")
  harbor_db_values_parsed                   = yamldecode(local.harbor_db_values)
  harbor_db_existing_secret                 = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  harbor_db_user_password_key               = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
  harbor_db_admin_password_key              = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey

  keycloak_values                             = file("${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}/values.yaml")
  keycloak_values_parsed                      = yamldecode(local.keycloak_values)
  keycloak_namespace                          = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}/config.json")).namespace
  keycloak_existing_admin_password_secret     = local.keycloak_values_parsed.keycloak.auth.existingSecret
  keycloak_existing_admin_password_secret_key = local.keycloak_values_parsed.keycloak.auth.passwordSecretKey
  keycloak_admin_password                     = data.kubernetes_secret.keycloak_existing_admin_password.data["${local.keycloak_existing_admin_password_secret_key}"]
  keycloak_url                                = "https://${local.keycloak_values_parsed.keycloak.ingress.hostname}"
  keycloak_db_values                          = file("${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}-db/values.yaml")
  keycloak_db_values_parsed                   = yamldecode(local.keycloak_db_values)
  keycloak_db_existing_secret                 = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  keycloak_db_user_password_key               = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
  keycloak_db_admin_password_key              = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey

  kube_prometheus_stack_values             = file("${var.helm_values_path}/${var.cluster_name}/${var.kube_prometheus_stack_chart_name}/values.yaml")
  kube_prometheus_stack_values_parsed      = yamldecode(local.kube_prometheus_stack_values)
  grafana_namespace                        = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.kube_prometheus_stack_chart_name}/config.json")).namespace
  grafana_url                              = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana["grafana.ini"].server.root_url
  grafana_existing_oauth_client_secret     = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana.envValueFrom.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET.secretKeyRef.name
  grafana_existing_oauth_client_secret_key = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana.envValueFrom.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET.secretKeyRef.key

  argo_workflows_values                                 = file("${var.helm_values_path}/${var.cluster_name}/${var.argo_workflows_chart_name}/values.yaml")
  argo_workflows_values_parsed                          = yamldecode(local.argo_workflows_values)
  argo_workflows_url                                    = "https://${local.argo_workflows_values_parsed.argo-workflows.server.ingress.hosts.0}"
  argo_workflows_redirect_uri                           = local.argo_workflows_values_parsed.argo-workflows.server.sso.redirectUrl
  argo_workflows_namespace                              = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.argo_workflows_chart_name}/config.json")).namespace
  argo_workflows_existing_sso_server_client_id_name     = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientId.name
  argo_workflows_existing_sso_server_client_id_key      = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientId.key
  argo_workflows_existing_sso_server_client_secret_name = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientSecret.name
  argo_workflows_existing_sso_server_client_secret_key  = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientSecret.key
  argo_workflows_workflow_namespace                     = local.argo_workflows_values_parsed.argo-workflows.controller.workflowNamespaces.0

  alertmanager_oauth2_proxy_namespace     = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/config.json")).namespace
  alertmanager_oauth2_proxy_values        = file("${var.helm_values_path}/${var.cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/values.yaml")
  alertmanager_oauth2_proxy_values_parsed = yamldecode(local.alertmanager_oauth2_proxy_values)
  alertmanager_url                        = "https://${local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"

  prometheus_oauth2_proxy_namespace     = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/config.json")).namespace
  prometheus_oauth2_proxy_values        = file("${var.helm_values_path}/${var.cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/values.yaml")
  prometheus_oauth2_proxy_values_parsed = yamldecode(local.prometheus_oauth2_proxy_values)
  prometheus_url                        = "https://${local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"

  oauth2_proxy_cache_namespace = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.oauth2_proxy_cache_chart_name}/config.json")).namespace
  oauth2_proxy_cache_values    = file("${var.helm_values_path}/${var.cluster_name}/${var.oauth2_proxy_cache_chart_name}/values.yaml")
}

# Providers

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

provider "keycloak" {
  alias     = "kcadmin-provider"
  client_id = "admin-cli"
  username  = var.keycloak_admin_username
  password  = local.keycloak_admin_password
  url       = local.keycloak_url
  # Ignoring certificate errors
  # because it might take some times
  # for certificates to be signed
  # by a trusted authority
  tls_insecure_skip_verify = true
}

provider "harbor" {
  alias    = "harboradmin-provider"
  url      = local.harbor_url
  username = var.harbor_admin_username
  password = local.harbor_admin_password
  # Ignoring certificate errors
  # because it might take some times
  # for certificates to be signed
  # by a trusted authority
  insecure = true
}

# Random passwords

resource "random_password" "argocd_keycloak_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "argo_workflows_keycloak_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "grafana_keycloak_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "alertmanager_keycloak_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "prometheus_keycloak_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "grafana_admin_password" {
  length  = 32
  special = false
}

data "kubernetes_secret" "harbor_existing_admin_password" {
  metadata {
    name      = local.harbor_existing_admin_password_secret
    namespace = local.harbor_namespace
  }
}

data "kubernetes_secret" "keycloak_existing_admin_password" {
  metadata {
    name      = local.keycloak_existing_admin_password_secret
    namespace = local.keycloak_namespace
  }
}

data "kubernetes_secret" "harbor_oidc" {
  metadata {
    name      = local.harbor_existing_oidc_secret
    namespace = local.harbor_namespace
  }
}

data "kubernetes_secret" "keycloak_db_existing_secret" {
  metadata {
    name      = local.keycloak_db_existing_secret
    namespace = local.keycloak_namespace
  }
}

data "kubernetes_secret" "harbor_db_existing_secret" {
  metadata {
    name      = local.harbor_db_existing_secret
    namespace = local.harbor_namespace
  }
}

# Grafana

resource "kubernetes_namespace" "grafana" {
  metadata {
    name = local.grafana_namespace
  }
}

resource "kubernetes_secret" "grafana_oauth_client_secret" {
  metadata {
    name      = local.grafana_existing_oauth_client_secret
    namespace = local.grafana_namespace
  }

  data = {
    "admin-password"                                    = random_password.grafana_admin_password.result
    "admin-user"                                        = var.grafana_admin_username
    "${local.grafana_existing_oauth_client_secret_key}" = random_password.grafana_keycloak_client_secret.result
  }

  depends_on = [kubernetes_namespace.grafana]
}

# Argo Workflows

# Given Argo Workflows values.yaml file,
# the SSO server clientId and clientSecret
# are potentially stored in two different secrets
# we use Terraform's "count" with conditional check
# to account for each case

resource "kubernetes_namespace" "argo" {
  metadata {
    name = local.argo_workflows_workflow_namespace
  }
}

resource "kubernetes_secret" "argo_workflows_oidc_client_id_and_secret" {
  metadata {
    name      = local.argo_workflows_existing_sso_server_client_id_name
    namespace = local.argo_workflows_namespace
  }

  data = {
    "${local.argo_workflows_existing_sso_server_client_id_key}"     = var.argo_workflows_keycloak_client_id
    "${local.argo_workflows_existing_sso_server_client_secret_key}" = random_password.argo_workflows_keycloak_client_secret.result
  }
  count = local.argo_workflows_existing_sso_server_client_secret_name == local.argo_workflows_existing_sso_server_client_id_name ? 1 : 0
}

resource "kubernetes_secret" "argo_workflows_oidc_client_id" {
  metadata {
    name      = local.argo_workflows_existing_sso_server_client_id_name
    namespace = local.argo_workflows_namespace
  }

  data = {
    "${local.argo_workflows_existing_sso_server_client_id_key}" = var.argo_workflows_keycloak_client_id
  }
  count = local.argo_workflows_existing_sso_server_client_secret_name != local.argo_workflows_existing_sso_server_client_id_name ? 1 : 0
}

resource "kubernetes_secret" "argo_workflows_oidc_client_secret" {
  metadata {
    name      = local.argo_workflows_existing_sso_server_client_secret_name
    namespace = local.argo_workflows_namespace
  }

  data = {
    "${local.argo_workflows_existing_sso_server_client_secret_key}" = random_password.argo_workflows_keycloak_client_secret.result
  }
  count = local.argo_workflows_existing_sso_server_client_secret_name != local.argo_workflows_existing_sso_server_client_id_name ? 1 : 0
}

module "oauth2_proxy" {
  source = "../modules/oauth2_proxy"

  alertmanager_oauth2_proxy_values    = local.alertmanager_oauth2_proxy_values
  prometheus_oauth2_proxy_values      = local.prometheus_oauth2_proxy_values
  oauth2_proxy_cache_values           = local.oauth2_proxy_cache_values
  alertmanager_oauth2_proxy_namespace = local.alertmanager_oauth2_proxy_namespace
  prometheus_oauth2_proxy_namespace   = local.prometheus_oauth2_proxy_namespace
  oauth2_proxy_cache_namespace        = local.oauth2_proxy_cache_namespace
  prometheus_keycloak_client_id       = var.prometheus_keycloak_client_id
  prometheus_keycloak_client_secret   = random_password.prometheus_keycloak_client_secret.result
  alertmanager_keycloak_client_id     = var.alertmanager_keycloak_client_id
  alertmanager_keycloak_client_secret = random_password.alertmanager_keycloak_client_secret.result
}

# Install charts

module "keycloak_config" {
  source = "../modules/keycloak_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  admin_id   = var.keycloak_admin_username
  realm_name = var.keycloak_realm
}

module "keycloak_harbor_client_config" {
  source = "../modules/keycloak_generic_client_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  realm_id            = module.keycloak_config.infra_realm_id
  client_id           = var.harbor_keycloak_client_id
  client_secret       = local.harbor_keycloak_client_secret
  root_url            = local.harbor_url
  base_url            = var.harbor_keycloak_base_url
  admin_url           = local.harbor_url
  web_origins         = [local.harbor_url]
  valid_redirect_uris = [join("/", [local.harbor_url, "c/oidc/callback"])]
  client_group        = var.harbor_keycloak_oidc_admin_group
}

module "keycloak_argocd_client_config" {
  source = "../modules/keycloak_generic_client_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  realm_id            = module.keycloak_config.infra_realm_id
  client_id           = var.argocd_keycloak_client_id
  client_secret       = random_password.argocd_keycloak_client_secret.result
  root_url            = module.argo_cd.argocd_url
  base_url            = var.argocd_keycloak_base_url
  admin_url           = module.argo_cd.argocd_url
  web_origins         = [module.argo_cd.argocd_url]
  valid_redirect_uris = [join("/", [module.argo_cd.argocd_url, "auth/callback"])]
  client_group        = var.argocd_keycloak_oidc_admin_group
}

module "keycloak_argo_workflows_client_config" {
  source = "../modules/keycloak_generic_client_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  realm_id            = module.keycloak_config.infra_realm_id
  client_id           = var.argo_workflows_keycloak_client_id
  client_secret       = random_password.argo_workflows_keycloak_client_secret.result
  root_url            = local.argo_workflows_url
  base_url            = var.argo_workflows_keycloak_base_url
  admin_url           = local.argo_workflows_url
  web_origins         = [local.argo_workflows_url]
  valid_redirect_uris = [local.argo_workflows_redirect_uri]
  client_group        = var.argo_workflows_keycloak_oidc_admin_group
}

module "keycloak_grafana_client_config" {
  source = "../modules/keycloak_grafana_client_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  realm_id            = module.keycloak_config.infra_realm_id
  client_id           = var.grafana_keycloak_client_id
  client_secret       = random_password.grafana_keycloak_client_secret.result
  root_url            = local.grafana_url
  base_url            = var.grafana_keycloak_base_url
  admin_url           = local.grafana_url
  web_origins         = [local.grafana_url]
  valid_redirect_uris = [join("/", [local.grafana_url, "login/generic_oauth"])]
  client_group        = var.grafana_keycloak_oidc_admin_group
}

module "keycloak_alertmanager_client_config" {
  source = "../modules/keycloak_oauth2_proxy_client_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  realm_id            = module.keycloak_config.infra_realm_id
  client_id           = var.alertmanager_keycloak_client_id
  client_secret       = random_password.alertmanager_keycloak_client_secret.result
  root_url            = local.alertmanager_url
  base_url            = var.alertmanager_keycloak_base_url
  admin_url           = local.alertmanager_url
  web_origins         = [local.alertmanager_url]
  valid_redirect_uris = [join("/", [local.alertmanager_url, "*"])]
}

module "keycloak_prometheus_client_config" {
  source = "../modules/keycloak_oauth2_proxy_client_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  realm_id            = module.keycloak_config.infra_realm_id
  client_id           = var.prometheus_keycloak_client_id
  client_secret       = random_password.prometheus_keycloak_client_secret.result
  root_url            = local.prometheus_url
  base_url            = var.prometheus_keycloak_base_url
  admin_url           = local.prometheus_url
  web_origins         = [local.prometheus_url]
  valid_redirect_uris = [join("/", [local.prometheus_url, "*"]), join("/", [local.alertmanager_url, "*"])]
}

module "harbor_config" {
  source = "../modules/harbor_config"

  providers = {
    harbor = harbor.harboradmin-provider
  }

  charts_versions               = local.charts_versions
  source_helm_registry          = var.helm_registry
  source_helm_registry_username = var.helm_registry_username
  source_helm_registry_password = var.helm_registry_password

  harbor_admin_username = var.harbor_admin_username
  harbor_admin_password = local.harbor_admin_password
  harbor_helm_values    = file("${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}/values.yaml")

  github_actions_robot_username = var.github_actions_harbor_robot_username
  argocd_robot_username         = var.argocd_harbor_robot_username
  chorusci_robot_username       = var.chorusci_harbor_robot_username
  renovate_robot_username       = var.renovate_harbor_robot_username
}

module "argo_cd" {
  source = "../modules/argo_cd"

  providers = {
    helm = helm.chorus_helm
  }

  cluster_name  = var.cluster_name
  helm_registry = var.helm_registry

  argocd_chart_name    = var.argocd_chart_name
  argocd_chart_version = local.argocd_chart_version
  argocd_helm_values   = file("${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/values.yaml")
  argocd_namespace     = local.argocd_namespace

  argocd_cache_chart_name    = var.valkey_chart_name
  argocd_cache_chart_version = local.argocd_cache_chart_version
  argocd_cache_helm_values   = file("${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}-cache/values.yaml")

  helm_charts_values_credentials_secret = var.helm_values_credentials_secret
  helm_values_url                       = "https://github.com/${var.github_orga}/${var.helm_values_repo}"
  helm_values_pat                       = var.helm_values_pat
  harbor_domain                         = replace(local.harbor_url, "https://", "")
  harbor_robot_username                 = var.argocd_harbor_robot_username
  harbor_robot_password                 = module.harbor_config.argocd_robot_password
}

resource "null_resource" "wait_for_argocd" {
  provisioner "local-exec" {
    quiet       = true
    command     = <<EOT
      set -e
      i=0
      while [ $i -lt 30 ]; do
        if [ "$(curl -skf -o /dev/null -w "%%{http_code}" ${module.argo_cd.argocd_url}/healthz)" -eq 200 ]; then
          exit 0
        else
          echo "Waiting for ArgoCD... ($i)"
          sleep 10
        fi
        i=$((i+1))
      done
      echo "Timed out waiting for ArgoCD" >&2
      exit 1
    EOT
    interpreter = ["/bin/sh", "-c"]
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [module.argo_cd]
}

module "argocd_config" {
  source = "../modules/argo_cd_config"

  cluster_name = var.cluster_name

  argocd_helm_values = file("${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/values.yaml")
  argocd_namespace   = local.argocd_namespace

  helm_values_url      = "https://github.com/${var.github_orga}/${var.helm_values_repo}"
  helm_values_revision = var.chorus_release
  helm_registry        = var.helm_registry

  argo_deploy_chart_name    = var.argo_deploy_chart_name
  argo_deploy_chart_version = local.argo_deploy_chart_version
  argo_deploy_helm_values   = file("${var.helm_values_path}/${var.cluster_name}/${var.argo_deploy_chart_name}/values.yaml")

  harbor_domain      = replace(local.harbor_url, "https://", "")
  oidc_endpoint      = join("/", [local.keycloak_url, "realms", var.keycloak_realm])
  oidc_client_id     = var.argocd_keycloak_client_id
  oidc_client_secret = random_password.argocd_keycloak_client_secret.result

  depends_on = [
    module.argo_cd,
    null_resource.wait_for_argocd
  ]
}

module "chorus_ci" {
  source = "../modules/chorus_ci"

  chorusci_namespace   = local.chorusci_namespace
  chorusci_helm_values = file("${var.helm_values_path}/${var.cluster_name}/${var.chorusci_chart_name}/values.yaml")

  github_chorus_web_ui_token      = var.github_chorus_web_ui_token
  github_images_token             = var.github_images_token
  github_chorus_backend_token     = var.github_chorus_backend_token
  github_workbench_operator_token = var.github_workbench_operator_token

  github_username = var.github_username

  registry_server   = local.harbor_url
  registry_username = var.chorusci_harbor_robot_username
  registry_password = module.harbor_config.chorusci_robot_password
}

locals {
  output = {
    harbor_admin_username = var.harbor_admin_username
    harbor_admin_password = local.harbor_admin_password
    harbor_url            = local.harbor_url
    harbor_admin_url      = join("/", [local.harbor_url, "account", "sign-in"])

    harbor_chorusci_robot_password = module.harbor_config.chorusci_robot_password
    harbor_argocd_robot_password   = module.harbor_config.argocd_robot_password
    harbor_renovate_robot_password = module.harbor_config.renovate_robot_password
    harbor_db_username             = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.username
    harbor_db_password             = data.kubernetes_secret.harbor_db_existing_secret.data["${local.harbor_db_user_password_key}"]
    harbor_db_admin_username       = "postgres"
    harbor_db_admin_password       = data.kubernetes_secret.harbor_db_existing_secret.data["${local.harbor_db_admin_password_key}"]

    keycloak_admin_username    = var.keycloak_admin_username
    keycloak_admin_password    = local.keycloak_admin_password
    keycloak_url               = local.keycloak_url
    keycloak_db_username       = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.username
    keycloak_db_password       = data.kubernetes_secret.keycloak_db_existing_secret.data["${local.keycloak_db_user_password_key}"]
    keycloak_db_admin_username = "postgres"
    keycloak_db_admin_password = data.kubernetes_secret.keycloak_db_existing_secret.data["${local.keycloak_db_admin_password_key}"]

    argocd_url      = module.argo_cd.argocd_url
    argocd_username = module.argo_cd.argocd_username
    argocd_password = module.argo_cd.argocd_password
  }
}

resource "local_file" "stage_02_output" {
  filename = "../output.yaml"
  content  = yamlencode(local.output)
}