# TODO: create all secrets needed for one remote cluster (e.g. chorus-dev)

locals {
  cert_manager_crds_content = file(var.cert_manager_crds_path)
}

# Cert-Manager CRDs

module "cert_manager_crds" {
  source = "../cert_manager_crds"

  cert_manager_crds_content = local.cert_manager_crds_content
}

# Keycloak

resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = var.keycloak_namespace
  }
}

module "keycloak_db_secret" {
  source = "../db_secret"

  namespace           = var.local.keycloak_namespace
  secret_name         = var.local.keycloak_db_secret_name
  db_user_secret_key  = var.local.keycloak_db_user_secret_key
  db_admin_secret_key = var.local.keycloak_db_admin_secret_key

  depends_on = [kubernetes_namespace.keycloak]
}

module "keycloak_secret" {
  source = "../keycloak_secret"

  namespace   = var.keycloak_namespace
  secret_name = var.keycloak_secret_name
  secret_key  = var.keycloak_secret_key

  depends_on = [kubernetes_namespace.keycloak]
}

# Harbor

resource "kubernetes_namespace" "harbor" {
  metadata {
    name = var.harbor_namespace
  }
}

module "harbor_db_secret" {
  source = "../db_secret"

  namespace           = var.local.harbor_namespace
  secret_name         = var.local.harbor_db_secret_name
  db_user_secret_key  = var.local.harbor_db_user_secret_key
  db_admin_secret_key = var.local.harbor_db_admin_secret_key

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


# need to upload the following charts
# - backend 0.1.15
# - matomo 0.0.9
# - web-ui 1.3.4
# - workbench-operator 0.3.17
# helm pull oci://harbor.build.chorus-tre.ch/charts/workbench-operator --version 0.3.17

# Backend

# backend-service-account service account in backend namespace
# >> backend/values.deployment.serviceAccountName
# secrets:
# - name: backend-service-account-secret

# backend-postgresql secret in backend namespace
# admin-password:
# postgres-password:
# replication-password:
# user-password:

# Matomo

# matomo-mariadb-secret secret in matomo namespace
# db-password:

# Web-UI / Frontend

# regcred secret in frontend namespace
# .dockerconfigjson
# or is this created by reflector?!

