locals {
  release_desc        = file("../values/${var.cluster_name}/charts_versions.yaml")
  release_desc_parsed = yamldecode(local.release_desc)

  harbor_values                             = file("${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}/values.yaml")
  harbor_values_parsed                      = yamldecode(local.harbor_values)
  harbor_namespace                          = local.harbor_values_parsed.harbor.namespace
  harbor_existing_admin_password_secret     = local.harbor_values_parsed.harbor.existingSecretAdminPassword
  harbor_existing_admin_password_secret_key = local.harbor_values_parsed.harbor.existingSecretAdminPasswordKey
  harbor_admin_password                     = data.kubernetes_secret.harbor_existing_admin_password.data["${local.harbor_existing_admin_password_secret_key}"]
  harbor_url                                = local.harbor_values_parsed.harbor.externalURL
  harbor_existing_oidc_secret               = local.harbor_values_parsed.harbor.core.extraEnvVars.0.valueFrom.secretKeyRef.name
  harbor_existing_oidc_secret_key           = local.harbor_values_parsed.harbor.core.extraEnvVars.0.valueFrom.secretKeyRef.key
  harbor_keycloak_client_secret             = jsondecode(data.kubernetes_secret.harbor_oidc.data["${local.harbor_existing_oidc_secret_key}"]).oidc_client_secret

  keycloak_values                             = file("${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}/values.yaml")
  keycloak_values_parsed                      = yamldecode(local.keycloak_values)
  keycloak_namespace                          = local.keycloak_values_parsed.keycloak.namespaceOverride
  keycloak_existing_admin_password_secret     = local.keycloak_values_parsed.keycloak.auth.existingSecret
  keycloak_existing_admin_password_secret_key = local.keycloak_values_parsed.keycloak.auth.passwordSecretKey
  keycloak_admin_password                     = data.kubernetes_secret.keycloak_existing_admin_password.data["${local.keycloak_existing_admin_password_secret_key}"]
  keycloak_url                                = "https://${local.keycloak_values_parsed.keycloak.ingress.hostname}"

  kube_prometheus_stack_values             = file("${var.helm_values_path}/${var.cluster_name}/${var.kube_prometheus_stack_chart_name}/values.yaml")
  kube_prometheus_stack_values_parsed      = yamldecode(local.kube_prometheus_stack_values)
  grafana_namespace                        = "prometheus" # TODO: read all namespaces from the helm charts config.json
  grafana_url                              = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana["grafana.ini"].server.root_url
  grafana_existing_oauth_client_secret     = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana.envValueFrom.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET.secretKeyRef.name
  grafana_existing_oauth_client_secret_key = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana.envValueFrom.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET.secretKeyRef.key

  argo_workflows_values                                 = file("${var.helm_values_path}/${var.cluster_name}/${var.argo_workflows_chart_name}/values.yaml")
  argo_workflows_values_parsed                          = yamldecode(local.argo_workflows_values)
  argo_workflows_url                                    = "https://${local.argo_workflows_values_parsed.argo-workflows.server.ingress.hosts.0}"
  argo_workflows_redirect_uri                           = local.argo_workflows_values_parsed.argo-workflows.server.sso.redirectUrl
  argo_workflows_namespace                              = "kube-system" # TODO: read all namespaces from the helm charts config.json
  argo_workflows_existing_sso_server_client_id_name     = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientId.name
  argo_workflows_existing_sso_server_client_id_key      = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientId.key
  argo_workflows_existing_sso_server_client_secret_name = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientSecret.name
  argo_workflows_existing_sso_server_client_secret_key  = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientSecret.key
  argo_workflows_workflow_namespace                     = local.argo_workflows_values_parsed.argo-workflows.controller.workflowNamespaces.0

  alertmanager_oauth2_proxy_namespace           = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/config.json")).namespace
  alertmanager_oauth2_proxy_values              = file("${var.helm_values_path}/${var.cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/values.yaml")
  alertmanager_oauth2_proxy_values_parsed       = yamldecode(local.alertmanager_oauth2_proxy_values)
  alertmanager_oauth2_proxy_existing_secret     = local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.existingSecret
  alertmanager_oauth2_proxy_existing_secret_key = local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.passwordKey
  alertmanager_url                              = "https://${local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"
  alertmanager_existing_oidc_secret             = local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.config.existingSecret

  prometheus_oauth2_proxy_namespace           = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/config.json")).namespace
  prometheus_oauth2_proxy_values              = file("${var.helm_values_path}/${var.cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/values.yaml")
  prometheus_oauth2_proxy_values_parsed       = yamldecode(local.prometheus_oauth2_proxy_values)
  prometheus_oauth2_proxy_existing_secret     = local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.existingSecret
  prometheus_oauth2_proxy_existing_secret_key = local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.passwordKey
  prometheus_url                              = "https://${local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"
  prometheus_existing_oidc_secret             = local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.config.existingSecret

  valkey_oauth2_proxy_namespace           = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.valkey_oauth2_proxy_chart_name}/config.json")).namespace
  valkey_oauth2_proxy_values              = file("${var.helm_values_path}/${var.cluster_name}/${var.valkey_oauth2_proxy_chart_name}/values.yaml")
  valkey_oauth2_proxy_values_parsed       = yamldecode(local.valkey_oauth2_proxy_values)
  valkey_oauth2_proxy_existing_secret     = local.valkey_oauth2_proxy_values_parsed.valkey.auth.existingSecret
  valkey_oauth2_proxy_existing_secret_key = local.valkey_oauth2_proxy_values_parsed.valkey.auth.existingSecretPasswordKey

  harbor_keycloak_client_config = {
    "${var.harbor_keycloak_client_id}" = {
      client_secret       = local.harbor_keycloak_client_secret
      root_url            = local.harbor_url
      base_url            = var.harbor_keycloak_base_url
      admin_url           = local.harbor_url
      web_origins         = [local.harbor_url]
      valid_redirect_uris = [join("/", [local.harbor_url, "c/oidc/callback"])]
      client_group        = var.harbor_keycloak_oidc_admin_group
    }
  }

  argocd_keycloak_client_config = {
    "${var.argocd_keycloak_client_id}" = {
      client_secret       = random_password.argocd_keycloak_client_secret.result
      root_url            = module.argo_cd.argocd_url
      base_url            = var.argocd_keycloak_base_url
      admin_url           = module.argo_cd.argocd_url
      web_origins         = [module.argo_cd.argocd_url]
      valid_redirect_uris = [join("/", [module.argo_cd.argocd_url, "auth/callback"])]
      client_group        = var.argocd_keycloak_oidc_admin_group
    }
  }

  argo_workflows_keycloak_client_config = {
    "${var.argo_workflows_keycloak_client_id}" = {
      client_secret       = random_password.argo_workflows_keycloak_client_secret.result
      root_url            = local.argo_workflows_url
      base_url            = var.argo_workflows_keycloak_base_url
      admin_url           = local.argo_workflows_url
      web_origins         = [local.argo_workflows_url]
      valid_redirect_uris = [local.argo_workflows_redirect_uri]
      client_group        = var.argo_workflows_keycloak_oidc_admin_group
    }
  }

  grafana_keycloak_client_config = {
    "${var.grafana_keycloak_client_id}" = {
      client_secret       = random_password.grafana_keycloak_client_secret.result
      root_url            = local.grafana_url
      base_url            = var.grafana_keycloak_base_url
      admin_url           = local.grafana_url
      web_origins         = [local.grafana_url]
      valid_redirect_uris = [join("/", [local.grafana_url, "login/generic_oauth"])]
      client_group        = var.grafana_keycloak_oidc_admin_group
    }
  }

  alertmanager_keycloak_client_config = {
    "${var.alertmanager_keycloak_client_id}" = {
      client_secret       = random_password.alertmanager_keycloak_client_secret.result
      root_url            = local.alertmanager_url
      base_url            = var.alertmanager_keycloak_base_url
      admin_url           = local.alertmanager_url
      web_origins         = [local.alertmanager_url]
      valid_redirect_uris = [join("/", [local.alertmanager_url, "*"])]
      client_group        = var.alertmanager_keycloak_oidc_admin_group
    }
  }

  prometheus_keycloak_client_config = {
    "${var.prometheus_keycloak_client_id}" = {
      client_secret       = random_password.prometheus_keycloak_client_secret.result
      root_url            = local.prometheus_url
      base_url            = var.prometheus_keycloak_base_url
      admin_url           = local.prometheus_url
      web_origins         = [local.prometheus_url]
      valid_redirect_uris = [join("/", [local.prometheus_url, "*"]), join("/", [local.alertmanager_url, "*"])]
      client_group        = var.prometheus_keycloak_oidc_admin_group
    }
  }
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

resource "random_password" "alertmanager_cookie_secret" {
  length  = 32
  special = false
}

resource "random_password" "prometheus_cookie_secret" {
  length  = 32
  special = false
}

resource "random_password" "grafana_admin_password" {
  length  = 32
  special = false
}

# TODO: DEBUG
# [2025/06/26 15:48:02] [main.go:53] invalid configuration:
#  unable to set a redis initialization key: WRONGPASS invalid username-password pair or user is disabled.
#  unable to delete the redis initialization key: WRONGPASS invalid username-password pair or user is disabled.
# My guess: we need to feed the Valkey password instead of creating new ones

resource "random_password" "valkey_oauth2_proxy_secret" {
  length  = 32
  special = false
}

resource "random_password" "alertmanager_oauth2_proxy_secret" {
  length  = 32
  special = false
}

resource "random_password" "prometheus_oauth2_proxy_secret" {
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

# Alertmanager-oauth2-proxy
resource "kubernetes_secret" "alertmanager_oauth2_proxy_secret" {
  metadata {
    name      = local.alertmanager_oauth2_proxy_existing_secret
    namespace = local.alertmanager_oauth2_proxy_namespace
  }

  data = {
    "${local.alertmanager_oauth2_proxy_existing_secret_key}" = random_password.alertmanager_oauth2_proxy_secret.result
  }
}

resource "kubernetes_secret" "alertmanager_oidc_secret" {
  metadata {
    name      = local.alertmanager_existing_oidc_secret
    namespace = local.alertmanager_oauth2_proxy_namespace
  }

  data = {
    "cookie-secret" = random_password.alertmanager_cookie_secret.result
    "client-id"     = var.alertmanager_keycloak_client_id
    "client-secret" = random_password.alertmanager_keycloak_client_secret.result
  }
}

# Prometheus oauth2 proxy
resource "kubernetes_secret" "prometheus_oauth2_proxy_secret" {
  metadata {
    name      = local.prometheus_oauth2_proxy_existing_secret
    namespace = local.prometheus_oauth2_proxy_namespace
  }

  data = {
    "${local.prometheus_oauth2_proxy_existing_secret_key}" = random_password.prometheus_oauth2_proxy_secret.result
  }
}

resource "kubernetes_secret" "prometheus_oidc_secret" {
  metadata {
    name      = local.prometheus_existing_oidc_secret
    namespace = local.prometheus_oauth2_proxy_namespace
  }

  data = {
    "cookie-secret" = random_password.prometheus_cookie_secret.result
    "client-id"     = var.prometheus_keycloak_client_id
    "client-secret" = random_password.prometheus_keycloak_client_secret.result
  }
}

# Valkey oauth2 proxy
resource "kubernetes_secret" "valkey_oauth2_proxy_secret" {
  metadata {
    name      = local.valkey_oauth2_proxy_existing_secret
    namespace = local.valkey_oauth2_proxy_namespace
  }

  data = {
    "${local.valkey_oauth2_proxy_existing_secret_key}" = random_password.valkey_oauth2_proxy_secret.result
  }
}

# Install charts

module "keycloak_config" {
  source = "../modules/keycloak_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  admin_id   = var.keycloak_admin_username
  realm_name = var.keycloak_realm
  clients_config = merge(
    local.harbor_keycloak_client_config,
    local.argocd_keycloak_client_config,
    local.argo_workflows_keycloak_client_config,
    local.grafana_keycloak_client_config,
    local.alertmanager_keycloak_client_config,
    local.prometheus_keycloak_client_config
  )
}

module "harbor_config" {
  source = "../modules/harbor_config"

  providers = {
    harbor = harbor.harboradmin-provider
  }

  release_desc                  = local.release_desc
  source_helm_registry          = var.helm_registry
  source_helm_registry_username = var.helm_registry_username
  source_helm_registry_password = var.helm_registry_password

  harbor_admin_username = var.harbor_admin_username
  harbor_admin_password = local.harbor_admin_password
  harbor_helm_values    = file("${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}/values.yaml")

  argocd_robot_username = var.argocd_harbor_robot_username
  argoci_robot_username = var.argoci_harbor_robot_username
}

module "argo_cd" {
  source = "../modules/argo_cd"

  providers = {
    helm = helm.chorus_helm
  }

  cluster_name  = var.cluster_name
  helm_registry = var.helm_registry

  argocd_chart_name    = var.argocd_chart_name
  argocd_chart_version = local.release_desc_parsed.charts["${var.argocd_chart_name}"].version
  argocd_helm_values   = file("${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/values.yaml")

  argocd_cache_chart_name    = var.valkey_chart_name
  argocd_cache_chart_version = local.release_desc_parsed.charts["${var.valkey_chart_name}"].version
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
    quiet   = true
    command = <<EOT
      set -e
      for i in {1..30}; do
        if [ $(curl -skf -o /dev/null -w "%%{http_code}" ${module.argo_cd.argocd_url}/healthz) -eq 200 ]; then
          exit 0
        else
          echo "Waiting for ArgoCD... ($i)"
          sleep 10
        fi
      done
      echo "Timed out waiting for ArgoCD" >&2
      exit 1
    EOT
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [module.argo_cd]
}

module "argocd_config" {
  source = "../modules/argo_cd_config"

  cluster_name       = var.cluster_name
  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context

  argocd_helm_values   = file("${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/values.yaml")
  helm_values_url      = "https://github.com/${var.github_orga}/${var.helm_values_repo}"
  helm_values_revision = var.chorus_release
  helm_registry        = var.helm_registry

  argo_deploy_chart_name    = var.argo_deploy_chart_name
  argo_deploy_chart_version = local.release_desc_parsed.charts["${var.argo_deploy_chart_name}"].version
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

# Outputs

output "argocd_url" {
  value = try(module.argo_cd.argocd_url,
  "Failed to retrieve ArgoCD URL")
}

output "argocd_username" {
  value = try(module.argo_cd.argocd_username,
  "Failed to retrieve ArgoCD admin username ")
}

output "argocd_password" {
  value     = module.argo_cd.argocd_password
  sensitive = true
}

locals {
  output = {
    harbor_admin_username        = var.harbor_admin_username
    harbor_admin_password        = local.harbor_admin_password
    harbor_url                   = local.harbor_url
    harbor_admin_url             = join("/", [local.harbor_url, "account", "sign-in"])
    harbor_argoci_robot_password = module.harbor_config.argoci_robot_password
    harbor_argocd_robot_password = module.harbor_config.argocd_robot_password

    keycloak_admin_username = var.keycloak_admin_username
    keycloak_admin_password = local.keycloak_admin_password
    keycloak_url            = local.keycloak_url

    argocd_url      = module.argo_cd.argocd_url
    argocd_username = module.argo_cd.argocd_username
    argocd_password = module.argo_cd.argocd_password
  }
}

resource "local_file" "stage_02_output" {
  filename = "../output.yaml"
  content  = yamlencode(local.output)
}