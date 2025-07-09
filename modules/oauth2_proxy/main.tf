locals {
  alertmanager_oauth2_proxy_values_parsed          = yamldecode(var.alertmanager_oauth2_proxy_values)
  alertmanager_existing_session_storage_secret     = local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.existingSecret
  alertmanager_existing_session_storage_secret_key = local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.passwordKey
  alertmanager_url                                 = "https://${local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"
  alertmanager_existing_oidc_secret                = local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.config.existingSecret

  prometheus_oauth2_proxy_values_parsed          = yamldecode(var.prometheus_oauth2_proxy_values)
  prometheus_existing_session_storage_secret     = local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.existingSecret
  prometheus_existing_session_storage_secret_key = local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.passwordKey
  prometheus_url                                 = "https://${local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"
  prometheus_existing_oidc_secret                = local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.config.existingSecret

  valkey_values_parsed                       = yamldecode(var.valkey_values)
  valkey_existing_session_storage_secret     = local.valkey_values_parsed.valkey.auth.existingSecret
  valkey_existing_session_storage_secret_key = local.valkey_values_parsed.valkey.auth.existingSecretPasswordKey
}

resource "random_password" "prometheus_cookie_secret" {
  length  = 32
  special = false
}

resource "random_password" "alertmanager_cookie_secret" {
  length  = 32
  special = false
}

resource "random_password" "session_storage_secret" {
  length  = 32
  special = false
}

# Prometheus OAUTH2 proxy OIDC secret

resource "kubernetes_secret" "prometheus_oidc_secret" {
  metadata {
    name      = local.prometheus_existing_oidc_secret
    namespace = var.prometheus_oauth2_proxy_namespace
  }

  data = {
    "cookie-secret" = random_password.prometheus_cookie_secret.result
    "client-id"     = var.prometheus_keycloak_client_id
    "client-secret" = var.prometheus_keycloak_client_secret
  }
}

# Alertmanager OAUTH2 proxy OIDC secret

resource "kubernetes_secret" "alertmanager_oidc_secret" {
  metadata {
    name      = local.alertmanager_existing_oidc_secret
    namespace = var.alertmanager_oauth2_proxy_namespace
  }

  data = {
    "cookie-secret" = random_password.alertmanager_cookie_secret.result
    "client-id"     = var.alertmanager_keycloak_client_id
    "client-secret" = var.alertmanager_keycloak_client_secret
  }
}

# Prometheus session storage secret

resource "kubernetes_secret" "prometheus_session_storage_secret" {
  metadata {
    name      = local.prometheus_existing_session_storage_secret
    namespace = var.prometheus_oauth2_proxy_namespace
  }

  data = {
    "${local.prometheus_existing_session_storage_secret_key}" = random_password.session_storage_secret.result
  }
}

# Alertmanager session storage secret

resource "kubernetes_secret" "alertmanager_session_storage_secret" {
  metadata {
    name      = local.alertmanager_existing_session_storage_secret
    namespace = var.alertmanager_oauth2_proxy_namespace
  }

  data = {
    "${local.alertmanager_existing_session_storage_secret_key}" = random_password.session_storage_secret.result
  }
}

# Valkey session storage secret

resource "kubernetes_secret" "valkey_oauth2_proxy_secret" {
  metadata {
    name      = local.valkey_existing_session_storage_secret
    namespace = var.valkey_namespace
  }

  data = {
    "${local.valkey_existing_session_storage_secret_key}" = random_password.session_storage_secret.result
  }
}