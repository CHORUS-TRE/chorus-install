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
    name      = var.prometheus_oidc_secret_name
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
    name      = var.alertmanager_oidc_secret_name
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
    name      = var.prometheus_session_storage_secret_name
    namespace = var.prometheus_oauth2_proxy_namespace
  }

  data = {
    "${var.prometheus_session_storage_secret_key}" = random_password.session_storage_secret.result
  }
}

# Alertmanager session storage secret

resource "kubernetes_secret" "alertmanager_session_storage_secret" {
  metadata {
    name      = var.alertmanager_session_storage_secret_name
    namespace = var.alertmanager_oauth2_proxy_namespace
  }

  data = {
    "${var.alertmanager_session_storage_secret_key}" = random_password.session_storage_secret.result
  }
}

# Valkey session storage secret

resource "kubernetes_secret" "oauth2_proxy_cache_secret" {
  metadata {
    name      = var.oauth2_proxy_cache_session_storage_secret_name
    namespace = var.oauth2_proxy_cache_namespace
  }

  data = {
    "${var.oauth2_proxy_cache_session_storage_secret_key}" = random_password.session_storage_secret.result
  }
}