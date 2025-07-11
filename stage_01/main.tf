locals {
  ingress_nginx_chart_version = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.ingress_nginx_chart_name}/config.json")).version
  cert_manager_chart_version  = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.cert_manager_chart_name}/config.json")).version
  cert_manager_app_version    = file("${var.helm_values_path}/${var.cluster_name}/${var.cert_manager_chart_name}/app_version")
  selfsigned_chart_version    = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.selfsigned_chart_name}/config.json")).version
  keycloak_chart_version      = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}/config.json")).version
  keycloak_db_chart_version   = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}-db/config.json")).version
  harbor_chart_version        = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}/config.json")).version
  harbor_cache_chart_version  = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}-cache/config.json")).version
  harbor_db_chart_version     = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}-db/config.json")).version
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

  cluster_name  = var.cluster_name
  helm_registry = var.helm_registry

  chart_name         = var.ingress_nginx_chart_name
  chart_version      = local.ingress_nginx_chart_version
  helm_values        = file("${var.helm_values_path}/${var.cluster_name}/${var.ingress_nginx_chart_name}/values.yaml")
  namespace          = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.ingress_nginx_chart_name}/config.json")).namespace
  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
}

module "certificate_authorities" {
  source = "../modules/certificate_authorities"

  providers = {
    helm = helm.chorus_helm
  }

  cluster_name  = var.cluster_name
  helm_registry = var.helm_registry

  cert_manager_chart_name    = var.cert_manager_chart_name
  cert_manager_chart_version = local.cert_manager_chart_version
  cert_manager_app_version   = local.cert_manager_app_version
  cert_manager_helm_values   = file("${var.helm_values_path}/${var.cluster_name}/${var.cert_manager_chart_name}/values.yaml")
  cert_manager_namespace     = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.cert_manager_chart_name}/config.json")).namespace

  selfsigned_chart_name    = var.selfsigned_chart_name
  selfsigned_chart_version = local.selfsigned_chart_version
  selfsigned_helm_values   = file("${var.helm_values_path}/${var.cluster_name}/${var.selfsigned_chart_name}/values.yaml")

  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
}

module "keycloak" {
  source = "../modules/keycloak"

  providers = {
    helm = helm.chorus_helm
  }

  cluster_name  = var.cluster_name
  helm_registry = var.helm_registry

  keycloak_chart_name    = var.keycloak_chart_name
  keycloak_chart_version = local.keycloak_chart_version
  keycloak_helm_values   = file("${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}/values.yaml")
  keycloak_namespace     = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}/config.json")).namespace

  keycloak_db_chart_name    = var.postgresql_chart_name
  keycloak_db_chart_version = local.keycloak_db_chart_version
  keycloak_db_helm_values   = file("${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}-db/values.yaml")

  depends_on = [
    module.certificate_authorities,
    module.ingress_nginx
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

  harbor_chart_name    = var.harbor_chart_name
  harbor_chart_version = local.harbor_chart_version
  harbor_helm_values   = file("${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}/values.yaml")
  harbor_namespace     = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}/config.json")).namespace

  harbor_cache_chart_name    = var.valkey_chart_name
  harbor_cache_chart_version = local.harbor_cache_chart_version
  harbor_cache_helm_values   = file("${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}-cache/values.yaml")

  harbor_db_chart_name    = var.postgresql_chart_name
  harbor_db_chart_version = local.harbor_db_chart_version
  harbor_db_helm_values   = file("${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}-db/values.yaml")


  oidc_client_id        = var.harbor_keycloak_client_id
  oidc_client_secret    = random_password.harbor_keycloak_client_secret.result
  oidc_endpoint         = join("/", [module.keycloak.keycloak_url, "realms", var.keycloak_realm])
  oidc_admin_group      = var.harbor_keycloak_oidc_admin_group
  harbor_admin_username = var.harbor_admin_username

  depends_on = [
    module.certificate_authorities,
    module.ingress_nginx
  ]
}