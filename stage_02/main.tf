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

resource "random_password" "grafana_keycloak_client_secret" {
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

# Grafana

resource "kubernetes_namespace" "grafana" {
  metadata {
    name = local.grafana_namespace
  }
}

resource "kubernetes_secret" "grafana_oauth_client_secret" {
  metadata {
    name = local.grafana_existing_oauth_client_secret
    namespace = local.grafana_namespace
  }

  data = {
    "admin-password" = random_password.grafana_admin_password.result
    "admin-user" = var.grafana_admin_username
    "${local.grafana_existing_oauth_client_secret_key}" = random_password.grafana_keycloak_client_secret.result
  }

  depends_on = [ kubernetes_namespace.grafana ]
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
    local.argocd_keycloak_client_config
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


provider "argocd" {
  alias       = "argocdadmin_provider"
  username    = module.argo_cd.argocd_username
  password    = module.argo_cd.argocd_password
  server_addr = join("", [replace(module.argo_cd.argocd_url, "https://", ""), ":443"])
  # Ignoring certificate errors
  # because it might take some times
  # for certificates to be signed
  # by a trusted authority
  insecure = true
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

  providers = {
    argocd = argocd.argocdadmin_provider
  }

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

output "harbor_argoci_robot_password" {
  value     = module.harbor_config.argoci_robot_password
  sensitive = true
}

locals {
  output = {
    harbor_admin_username        = var.harbor_admin_username
    harbor_admin_password        = local.harbor_admin_password
    harbor_url                   = local.harbor_url
    harbor_admin_url             = join("/", [local.harbor_url, "account", "sign-in"])
    harbor_argoci_robot_password = module.harbor_config.argoci_robot_password

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