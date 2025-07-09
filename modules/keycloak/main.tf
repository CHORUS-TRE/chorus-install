locals {
  keycloak_values_parsed       = yamldecode(var.keycloak_helm_values)
  keycloak_existing_secret     = local.keycloak_values_parsed.keycloak.auth.existingSecret
  keycloak_password_secret_key = local.keycloak_values_parsed.keycloak.auth.passwordSecretKey

  keycloak_db_values_parsed      = yamldecode(var.keycloak_db_helm_values)
  keycloak_db_existing_secret    = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  keycloak_db_admin_password_key = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  keycloak_db_postgres_password  = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.postgresPassword
  keycloak_db_user_password_key  = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
}

# Namespace

resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = var.keycloak_namespace
  }
}

# Secrets

resource "random_password" "keycloak_db_password" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "keycloak_db_secret" {
  metadata {
    name      = local.keycloak_db_existing_secret
    namespace = var.keycloak_namespace
  }

  data = {
    "${local.keycloak_db_admin_password_key}" = local.keycloak_db_postgres_password
    "${local.keycloak_db_user_password_key}"  = random_password.keycloak_db_password.result
  }

  depends_on = [kubernetes_namespace.keycloak]
}

resource "random_password" "keycloak_password" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "keycloak_secret" {
  metadata {
    name      = local.keycloak_existing_secret
    namespace = var.keycloak_namespace
  }

  data = {
    "${local.keycloak_password_secret_key}" = random_password.keycloak_password.result
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

  set {
    name  = "postgresql.metrics.enabled"
    value = "false"
  }
  set {
    name  = "postgresql.metrics.serviceMonitor.enabled"
    value = "false"
  }

  depends_on = [kubernetes_namespace.keycloak]
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

  set {
    name  = "keycloak.metrics.enabled"
    value = "false"
  }
  set {
    name  = "keycloak.metrics.serviceMonitor.enabled"
    value = "false"
  }

  depends_on = [kubernetes_namespace.keycloak]
}

# Retrieve data for outputs

data "kubernetes_secret" "keycloak_admin_password" {
  metadata {
    name      = local.keycloak_values_parsed.keycloak.auth.existingSecret
    namespace = var.keycloak_namespace
  }

  depends_on = [helm_release.keycloak]
}