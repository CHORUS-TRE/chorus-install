# Read values
locals {
  harbor_values_parsed = yamldecode(var.harbor_helm_values)

  harbor_cache_values_parsed = yamldecode(var.harbor_cache_helm_values)

  harbor_db_values_parsed      = yamldecode(var.harbor_db_helm_values)
  harbor_db_existing_secret    = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  harbor_db_postgres_password  = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.postgresPassword
  harbor_db_user_password_key  = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
  harbor_db_admin_password_key = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey


  harbor_existing_secret                      = local.harbor_values_parsed.harbor.core.existingSecret
  harbor_existing_secret_secret_key           = local.harbor_values_parsed.harbor.existingSecretSecretKey
  harbor_existing_xsrf_secret                 = local.harbor_values_parsed.harbor.core.existingXsrfSecret
  harbor_existing_xsrf_secret_key             = local.harbor_values_parsed.harbor.core.existingXsrfSecretKey
  harbor_existing_admin_password_secret       = local.harbor_values_parsed.harbor.existingSecretAdminPassword
  harbor_existing_admin_password_secret_key   = local.harbor_values_parsed.harbor.existingSecretAdminPasswordKey
  harbor_existing_jobservice_secret           = local.harbor_values_parsed.harbor.jobservice.existingSecret
  harbor_existing_jobservice_secret_key       = local.harbor_values_parsed.harbor.jobservice.existingSecretKey
  harbor_existing_registry_http_secret        = local.harbor_values_parsed.harbor.registry.existingSecret
  harbor_existing_registry_http_secret_key    = local.harbor_values_parsed.harbor.registry.existingSecretKey
  harbor_existing_registry_credentials_secret = local.harbor_values_parsed.harbor.registry.credentials.existingSecret

  harbor_registry_admin_username = "admin"

  oidc_secret = [
    for env in local.harbor_values_parsed.harbor.core.extraEnvVars : env
    if env.name == "CONFIG_OVERWRITE_JSON"
  ][0].valueFrom.secretKeyRef
  oidc_config = <<EOT
  {
  "auth_mode": "oidc_auth",
  "primary_auth_mode": "true",
  "oidc_name": "Keycloak",
  "oidc_endpoint": "${var.oidc_endpoint}",
  "oidc_client_id": "${var.oidc_client_id}",
  "oidc_client_secret": "${var.oidc_client_secret}",
  "oidc_groups_claim": "groups",
  "oidc_admin_group": "${var.oidc_admin_group}",
  "oidc_scope": "openid,profile,offline_access,email",
  "oidc_verify_cert": "false",
  "oidc_auto_onboard": "true",
  "oidc_user_claim": "name"
  }
  EOT
} #TODO: set oidc_verify_cert to "true"

resource "kubernetes_namespace" "harbor" {
  metadata {
    name = var.harbor_namespace
  }
}

# Secret Definitions
# Check if the Kubernetes secret already exists
data "kubernetes_secret" "existing_secret_harbor_db" {
  metadata {
    name      = local.harbor_db_existing_secret
    namespace = var.harbor_namespace
  }
}

data "kubernetes_secret" "existing_secret_harbor" {
  metadata {
    name      = local.harbor_existing_secret
    namespace = var.harbor_namespace
  }
}

data "kubernetes_secret" "existing_secret_secret_key_harbor" {
  metadata {
    name      = local.harbor_existing_secret_secret_key
    namespace = var.harbor_namespace
  }
}

data "kubernetes_secret" "existing_xsrf_secret_harbor" {
  metadata {
    name      = local.harbor_existing_xsrf_secret
    namespace = var.harbor_namespace
  }
}

data "kubernetes_secret" "existing_admin_password_secret_harbor" {
  metadata {
    name      = local.harbor_existing_admin_password_secret
    namespace = var.harbor_namespace
  }
}

data "kubernetes_secret" "existing_jobservice_secret_harbor" {
  metadata {
    name      = local.harbor_existing_jobservice_secret
    namespace = var.harbor_namespace
  }
}

data "kubernetes_secret" "existing_registry_http_secret_harbor" {
  metadata {
    name      = local.harbor_existing_registry_http_secret
    namespace = var.harbor_namespace
  }
}

data "kubernetes_secret" "existing_registry_credentials_secret_harbor" {
  metadata {
    name      = local.harbor_existing_registry_credentials_secret
    namespace = var.harbor_namespace
  }
}

# Generate random password
resource "random_password" "harbor_db_password" {
  length  = 32
  special = false
}

resource "random_password" "harbor_secret" {
  # Must be a string of 16 chars.
  length  = 16
  special = false
}

resource "random_password" "harbor_secret_secret_key" {
  # Must be a string of 16 chars.
  length  = 16
  special = false
}

resource "random_password" "harbor_csrf_key" {
  length  = 32
  special = false
}

resource "random_password" "harbor_admin_password" {
  length  = 32
  special = false
}

resource "random_password" "harbor_jobservice_secret" {
  # Must be a string of 16 chars.
  length  = 16
  special = false
}

resource "random_password" "harbor_registry_http_secret" {
  # Must be a string of 16 chars.
  length  = 16
  special = false
}

resource "random_password" "harbor_registry_passwd" {
  length  = 32
  special = false
}

resource "random_password" "salt" {
  length  = 8
  special = false
}

# Create Kubernetes secret using existing password (if found) or using randomly generated one
resource "kubernetes_secret" "harbor_db_secret" {
  metadata {
    name      = local.harbor_db_existing_secret
    namespace = var.harbor_namespace
  }

  data = {
    "${local.harbor_db_admin_password_key}" = local.harbor_db_postgres_password
    "${local.harbor_db_user_password_key}" = try(data.kubernetes_secret.existing_secret_harbor_db.data["${local.harbor_db_user_password_key}"],
    random_password.harbor_db_password.result)
  }
}

resource "kubernetes_secret" "harbor_secret" {
  metadata {
    name      = local.harbor_existing_secret
    namespace = var.harbor_namespace
  }

  # Helm chart does not allow to change the secret key
  # which is why "secret" is hardoced here
  data = {
    "secret" = try(data.kubernetes_secret.existing_secret_harbor.data["secret"],
    random_password.harbor_secret.result)
  }
}

resource "kubernetes_secret" "harbor_secret_secret_key" {
  metadata {
    name      = local.harbor_existing_secret_secret_key
    namespace = var.harbor_namespace
  }

  # Helm chart does not allow to change the secret key
  # which is why "secretKey" is hardoced here
  data = {
    "secretKey" = try(data.kubernetes_secret.existing_secret_secret_key_harbor.data["secretKey"],
    random_password.harbor_secret_secret_key.result)
  }
}

resource "kubernetes_secret" "harbor_xsrf_secret" {
  metadata {
    name      = local.harbor_existing_xsrf_secret
    namespace = var.harbor_namespace
  }

  data = {
    "${local.harbor_existing_xsrf_secret_key}" = try(data.kubernetes_secret.existing_xsrf_secret_harbor.data["${local.harbor_existing_xsrf_secret_key}"],
    random_password.harbor_csrf_key.result)
  }
}

resource "kubernetes_secret" "harbor_admin_password_secret" {
  metadata {
    name      = local.harbor_existing_admin_password_secret
    namespace = var.harbor_namespace
  }

  data = {
    "${local.harbor_existing_admin_password_secret_key}" = try(data.kubernetes_secret.existing_admin_password_secret_harbor.data["${local.harbor_existing_admin_password_secret_key}"],
    random_password.harbor_admin_password.result)
  }
}

resource "kubernetes_secret" "harbor_jobservice_secret" {
  metadata {
    name      = local.harbor_existing_jobservice_secret
    namespace = var.harbor_namespace
  }

  data = {
    "${local.harbor_existing_jobservice_secret_key}" = try(data.kubernetes_secret.existing_jobservice_secret_harbor.data["${local.harbor_existing_jobservice_secret_key}"],
    random_password.harbor_jobservice_secret.result)
  }
}

resource "kubernetes_secret" "harbor_registry_http_secret" {
  metadata {
    name      = local.harbor_existing_registry_http_secret
    namespace = var.harbor_namespace
  }

  data = {
    "${local.harbor_existing_registry_http_secret_key}" = try(data.kubernetes_secret.existing_registry_http_secret_harbor.data["${local.harbor_existing_registry_http_secret_key}"],
    random_password.harbor_registry_http_secret.result)
  }
}

resource "htpasswd_password" "harbor_registry" {
  password = random_password.harbor_registry_passwd.result
  salt     = random_password.salt.result
}

resource "kubernetes_secret" "harbor_registry_credentials_secret" {
  metadata {
    name      = local.harbor_existing_registry_credentials_secret
    namespace = var.harbor_namespace
  }

  # Helm chart does not allow to change the secret key
  # which is why "REGISTRY_PASSWD" and
  # "REGISTRY_HTPASSWD" are hardoced here
  data = {
    "REGISTRY_PASSWD" = try(data.kubernetes_secret.existing_registry_credentials_secret_harbor.data["REGISTRY_PASSWD"],
    random_password.harbor_registry_passwd.result)
    "REGISTRY_HTPASSWD" = try(data.kubernetes_secret.existing_registry_credentials_secret_harbor.data["REGISTRY_HTPASSWD"],
    "${local.harbor_registry_admin_username}:${htpasswd_password.harbor_registry.bcrypt}")
  }
}

resource "kubernetes_secret" "oidc_secret" {
  metadata {
    name      = local.oidc_secret.name
    namespace = var.harbor_namespace
  }

  data = {
    "${local.oidc_secret.key}" = local.oidc_config
  }

  lifecycle {
    ignore_changes = [data]
  }

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

  depends_on = [
    kubernetes_namespace.harbor
  ]
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

data "kubernetes_secret" "harbor_admin_password" {
  metadata {
    name      = local.harbor_values_parsed.harbor.existingSecretAdminPassword
    namespace = var.harbor_namespace
  }

  depends_on = [helm_release.harbor]
}