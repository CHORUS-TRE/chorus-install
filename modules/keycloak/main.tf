# Namespace

resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = var.keycloak_namespace
  }
}

# Random passwords

## Keycloak admin password

resource "random_password" "keycloak_password" {
  length  = 32
  special = false
}

## Keycloak client secrets

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

resource "random_password" "harbor_keycloak_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "matomo_keycloak_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "chorus_keycloak_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "keycloak_remotestate_encryption_key" {
  length  = 32
  special = false
  upper   = false
}

# Secrets

module "db_secret" {
  source = "../db_secret"

  namespace           = var.keycloak_namespace
  secret_name         = var.keycloak_db_secret_name
  db_user_secret_key  = var.keycloak_db_user_secret_key
  db_admin_secret_key = var.keycloak_db_admin_secret_key

  depends_on = [kubernetes_namespace.keycloak]
}

# Kubernetes secret

resource "kubernetes_secret" "keycloak_secret" {
  metadata {
    name      = var.keycloak_secret_name
    namespace = var.keycloak_namespace
  }

  data = {
    "${var.keycloak_secret_key}" = random_password.keycloak_password.result
  }

  depends_on = [kubernetes_namespace.keycloak]
}

resource "kubernetes_secret" "build_keycloak_client_credentials" {
  # Build cluster
  count = var.cluster_type == "build" ? 1 : 0

  metadata {
    name      = var.keycloak_client_credentials_secret_name
    namespace = var.keycloak_namespace
  }

  data = {
    GOOGLE_CLIENT_ID             = var.google_identity_provider_client_id
    GOOGLE_CLIENT_SECRET         = var.google_identity_provider_client_secret
    ALERTMANAGER_CLIENT_SECRET   = random_password.alertmanager_keycloak_client_secret.result
    ARGO_CD_CLIENT_SECRET        = random_password.argocd_keycloak_client_secret.result
    ARGO_WORKFLOWS_CLIENT_SECRET = random_password.argo_workflows_keycloak_client_secret.result
    GRAFANA_CLIENT_SECRET        = random_password.grafana_keycloak_client_secret.result
    HARBOR_CLIENT_SECRET         = random_password.harbor_keycloak_client_secret.result
    PROMETHEUS_CLIENT_SECRET     = random_password.prometheus_keycloak_client_secret.result
  }

  depends_on = [kubernetes_namespace.keycloak]
}

resource "kubernetes_secret" "remote_keycloak_client_credentials" {
  # Remote cluster
  count = var.cluster_type == "build" ? 0 : 1

  metadata {
    name      = var.keycloak_client_credentials_secret_name
    namespace = var.keycloak_namespace
  }

  data = {
    GOOGLE_CLIENT_ID           = var.google_identity_provider_client_id
    GOOGLE_CLIENT_SECRET       = var.google_identity_provider_client_secret
    ALERTMANAGER_CLIENT_SECRET = random_password.alertmanager_keycloak_client_secret.result
    GRAFANA_CLIENT_SECRET      = random_password.grafana_keycloak_client_secret.result
    HARBOR_CLIENT_SECRET       = random_password.harbor_keycloak_client_secret.result
    MATOMO_CLIENT_SECRET       = random_password.matomo_keycloak_client_secret.result
    PROMETHEUS_CLIENT_SECRET   = random_password.prometheus_keycloak_client_secret.result
    CHORUS_CLIENT_SECRET       = random_password.chorus_keycloak_client_secret.result
  }

  depends_on = [kubernetes_namespace.keycloak]
}

resource "kubernetes_secret" "keycloak_remotestate_encryption_key" {
  metadata {
    name      = var.keycloak_remotestate_encryption_key_secret_name
    namespace = var.keycloak_namespace
  }

  data = {
    encryptionKey = random_password.keycloak_remotestate_encryption_key.result
  }

  depends_on = [kubernetes_namespace.keycloak]
}

# Keycloak DB (PostgreSQL)

resource "helm_release" "keycloak_db" {
  name             = "${var.cluster_name}-${var.keycloak_chart_name}-db"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.keycloak_db_chart_name}"
  version          = var.keycloak_db_chart_version
  namespace        = var.keycloak_namespace
  create_namespace = false
  wait             = true

  values = [var.keycloak_db_helm_values]

  set = [
    {
      name  = "postgresql.metrics.enabled"
      value = "false"
    },
    {
      name  = "postgresql.metrics.serviceMonitor.enabled"
      value = "false"
    }
  ]

  depends_on = [kubernetes_namespace.keycloak, module.db_secret]
}

# Keycloak Deployment

resource "helm_release" "keycloak" {
  name             = "${var.cluster_name}-${var.keycloak_chart_name}"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.keycloak_chart_name}"
  version          = var.keycloak_chart_version
  namespace        = var.keycloak_namespace
  create_namespace = false
  wait             = true

  values = [var.keycloak_helm_values]

  set = [
    {
      name  = "keycloak.metrics.enabled"
      value = "false"
    },
    {
      name  = "keycloak.metrics.serviceMonitor.enabled"
      value = "false"
    }
  ]

  depends_on = [kubernetes_namespace.keycloak, helm_release.keycloak_db]
}

# Retrieve data for outputs

data "kubernetes_secret" "keycloak_admin_password" {
  metadata {
    name      = var.keycloak_secret_name
    namespace = var.keycloak_namespace
  }

  depends_on = [helm_release.keycloak]
}