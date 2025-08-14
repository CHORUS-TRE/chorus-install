# Namespace

resource "kubernetes_namespace" "harbor" {
  metadata {
    name = var.harbor_namespace
  }
}

# Secrets

module "db_secret" {
  source = "../db_secret"

  namespace             = var.harbor_namespace
  secret_name           = var.harbor_db_secret_name
  db_user_secret_key  = var.harbor_db_user_secret_key
  db_admin_secret_key = var.harbor_db_admin_secret_key

  depends_on = [kubernetes_namespace.harbor]
}

module "harbor_secret" {
  source = "../harbor_secret"

  namespace                        = var.harbor_namespace
  secret_name                      = var.harbor_secret_name
  encryption_key_secret_name       = var.harbor_encryption_key_secret_name
  xsrf_secret_name                 = var.harbor_xsrf_secret_name
  xsrf_secret_key                  = var.harbor_xsrf_secret_key
  admin_secret_name                = var.harbor_admin_secret_name
  admin_secret_key                 = var.harbor_admin_secret_key
  jobservice_secret_name           = var.harbor_jobservice_secret_name
  jobservice_secret_key            = var.harbor_jobservice_secret_key
  registry_secret_name             = var.harbor_registry_http_secret_name
  registry_secret_key              = var.harbor_registry_http_secret_key
  registry_credentials_secret_name = var.harbor_registry_credentials_secret_name
  oidc_secret_name                 = var.harbor_oidc_secret_name
  oidc_secret_key                  = var.harbor_oidc_secret_key
  oidc_config                      = var.harbor_oidc_config

  depends_on = [kubernetes_namespace.harbor]
}

# Harbor Cache (Valkey)

resource "helm_release" "harbor_cache" {
  name             = "${var.cluster_name}-${var.harbor_chart_name}-cache"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.harbor_cache_chart_name}"
  version          = var.harbor_cache_chart_version
  namespace        = var.harbor_namespace
  create_namespace = false
  wait             = true

  values = [var.harbor_cache_helm_values]

  set {
    name  = "valkey.metrics.enabled"
    value = "false"
  }
  set {
    name  = "valkey.metrics.serviceMonitor.enabled"
    value = "false"
  }
  set {
    name  = "valkey.metrics.podMonitor.enabled"
    value = "false"
  }

  depends_on = [kubernetes_namespace.harbor]
}

# Harbor DB (PostgreSQL)

resource "helm_release" "harbor_db" {
  name             = "${var.cluster_name}-${var.harbor_chart_name}-db"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.harbor_db_chart_name}"
  version          = var.harbor_db_chart_version
  namespace        = var.harbor_namespace
  create_namespace = false
  wait             = true

  values = [var.harbor_db_helm_values]

  set {
    name  = "postgresql.metrics.enabled"
    value = "false"
  }
  set {
    name  = "postgresql.metrics.serviceMonitor.enabled"
    value = "false"
  }
}

# Harbor

resource "helm_release" "harbor" {
  name             = "${var.cluster_name}-${var.harbor_chart_name}"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.harbor_chart_name}"
  version          = var.harbor_chart_version
  namespace        = var.harbor_namespace
  create_namespace = false
  wait             = true

  values = [var.harbor_helm_values]

  set {
    name  = "harbor.metrics.enabled"
    value = "false"
  }
  set {
    name  = "harbor.metrics.serviceMonitor.enabled"
    value = "false"
  }
}

# Retrieve data for outputs

data "kubernetes_secret" "harbor_admin_password" {
  metadata {
    name      = var.harbor_admin_secret_name
    namespace = var.harbor_namespace
  }

  depends_on = [helm_release.harbor]
}