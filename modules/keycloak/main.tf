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

resource "random_password" "keycloak_db_admin_password" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "keycloak_db_secret" {
  metadata {
    name      = var.keycloak_db_secret_name
    namespace = var.keycloak_namespace
  }

  data = {
    "${var.keycloak_db_admin_secret_key}" = random_password.keycloak_db_admin_password.result
    "${var.keycloak_db_user_secret_key}"  = random_password.keycloak_db_password.result
  }

  depends_on = [kubernetes_namespace.keycloak]
}

resource "random_password" "keycloak_password" {
  length  = 32
  special = false
}

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
    name      = var.keycloak_secret_name
    namespace = var.keycloak_namespace
  }

  depends_on = [helm_release.keycloak]
}