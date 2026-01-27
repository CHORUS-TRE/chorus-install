# Random passwords

## Keycloak admin password

resource "random_password" "admin_password" {
  length  = 32
  special = false
}

## Keycloak client secrets

resource "random_password" "argocd_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "argo_workflows_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "grafana_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "alertmanager_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "prometheus_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "harbor_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "matomo_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "chorus_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "remotestate_encryption_key" {
  length  = 32
  special = false
  upper   = false
}

# Kubernetes secrets

resource "kubernetes_secret" "admin_secret" {
  metadata {
    name      = var.admin_secret_name
    namespace = var.namespace
  }

  data = {
    "${var.admin_secret_key}" = random_password.admin_password.result
  }
}

resource "kubernetes_secret" "build_keycloak_client_credentials" {
  # Build cluster
  count = var.cluster_type == "build" ? 1 : 0

  metadata {
    name      = var.client_credentials_secret_name
    namespace = var.namespace
  }

  data = {
    GOOGLE_CLIENT_ID             = var.google_identity_provider_client_id
    GOOGLE_CLIENT_SECRET         = var.google_identity_provider_client_secret
    ALERTMANAGER_CLIENT_SECRET   = random_password.alertmanager_client_secret.result
    ARGO_CD_CLIENT_SECRET        = random_password.argocd_client_secret.result
    ARGO_WORKFLOWS_CLIENT_SECRET = random_password.argo_workflows_client_secret.result
    GRAFANA_CLIENT_SECRET        = random_password.grafana_client_secret.result
    HARBOR_CLIENT_SECRET         = random_password.harbor_client_secret.result
    PROMETHEUS_CLIENT_SECRET     = random_password.prometheus_client_secret.result
  }
}

resource "kubernetes_secret" "remote_keycloak_client_credentials" {
  # Remote cluster
  count = var.cluster_type == "build" ? 0 : 1

  metadata {
    name      = var.client_credentials_secret_name
    namespace = var.namespace
  }

  data = {
    GOOGLE_CLIENT_ID           = var.google_identity_provider_client_id
    GOOGLE_CLIENT_SECRET       = var.google_identity_provider_client_secret
    ALERTMANAGER_CLIENT_SECRET = random_password.alertmanager_client_secret.result
    GRAFANA_CLIENT_SECRET      = random_password.grafana_client_secret.result
    HARBOR_CLIENT_SECRET       = random_password.harbor_client_secret.result
    MATOMO_CLIENT_SECRET       = random_password.matomo_client_secret.result
    PROMETHEUS_CLIENT_SECRET   = random_password.prometheus_client_secret.result
    CHORUS_CLIENT_SECRET       = random_password.chorus_client_secret.result
  }
}

resource "kubernetes_secret" "keycloak_remotestate_encryption_key" {
  metadata {
    name      = var.remotestate_encryption_key_secret_name
    namespace = var.namespace
  }

  data = {
    encryptionKey = random_password.remotestate_encryption_key.result
  }
}
