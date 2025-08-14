# TODO: create all secrets needed for one remote cluster (e.g. chorus-dev)

locals {
  # TODO: read from values.yaml files
  keycloak_namespace             = "keycloak"
  keycloak_existing_secret       = "keycloak-secret"
  keycloak_password_secret_key   = "adminPassword"
  keycloak_db_existing_secret    = "keycloak_db_secret"
  keycloak_db_admin_password_key = "postgres-password"
  keycloak_db_user_password_key  = "password"

  harbor_namespace             = "harbor"
  harbor_existing_secret       = "harbor-secret"
  harbor_password_secret_key   = "adminPassword"
  harbor_db_existing_secret    = "harbor_db_secret"
  harbor_db_admin_password_key = "postgres-password"
  harbor_db_user_password_key  = "password"

  harbor_existing_secret_secret_key           = "harbor-key"
  harbor_existing_xsrf_secret                 = "harbor-xsrf"
  harbor_existing_xsrf_secret_key             = "CSRF_KEY"
  harbor_existing_admin_password              = "harbor-admin-password"
  harbor_existing_secret_admin_password_key   = "HARBOR_ADMIN_PASSWORD"
  harbor_existing_jobservice_secret           = "harbor-jobservice"
  harbor_existing_jobservice_secret_key       = "JOBSERVICE_SECRET"
  harbor_existing_registry_http_secret        = "harbor-registry"
  harbor_existing_registry_http_secret_key    = "REGISTRY_HTTP_SECRET"
  harbor_existing_registry_credentials_secret = "harbor-registry-credentials"
  harbor_oidc_secret                          = "harbor-oidc"
  harbor_oidc_secret_key                      = "CONFIG_OVERWRITE_JSON"
  harbor_oidc_config                          = <<EOT
  {
  "auth_mode": "oidc_auth",
  "primary_auth_mode": "true",
  "oidc_name": "Keycloak",
  "oidc_endpoint": "todo",
  "oidc_client_id": "todo",
  "oidc_client_secret": "todo",
  "oidc_groups_claim": "groups",
  "oidc_admin_group": "todo",
  "oidc_scope": "openid,profile,offline_access,email,groups",
  "oidc_verify_cert": "false",
  "oidc_auto_onboard": "true",
  "oidc_user_claim": "name"
  }
  EOT
}

# Keycloak

import {
  to = kubernetes_namespace.keycloak
  id = local.keycloak_namespace
}

resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = local.keycloak_namespace
  }
}

module "keycloak_db_secret" {
  source = "../db_secret"

  namespace             = local.keycloak_namespace
  secret_name           = local.keycloak_db_existing_secret
  db_user_password_key  = local.keycloak_db_user_password_key
  db_admin_password_key = local.keycloak_db_admin_password_key

  depends_on = [kubernetes_namespace.keycloak]
}

module "keycloak_secret" {
  source = "../keycloak_secret"

  namespace   = local.keycloak_namespace
  secret_name = local.keycloak_existing_secret
  secret_key  = local.keycloak_password_secret_key

  depends_on = [kubernetes_namespace.keycloak]
}

# Harbor

import {
  to = kubernetes_namespace.harbor
  id = local.harbor_namespace
}

resource "kubernetes_namespace" "harbor" {
  metadata {
    name = local.harbor_namespace
  }
}

module "harbor_db_secret" {
  source = "../db_secret"

  namespace             = local.harbor_namespace
  secret_name           = local.harbor_db_existing_secret
  db_user_password_key  = local.harbor_db_user_password_key
  db_admin_password_key = local.harbor_db_admin_password_key

  depends_on = [kubernetes_namespace.harbor]
}

module "harbor_secret" {
  source = "../harbor_secret"

  namespace                        = local.harbor_namespace
  secret_name                      = local.harbor_existing_secret
  secret_key_secret_name           = local.harbor_existing_secret_secret_key
  xsrf_secret_name                 = local.harbor_existing_xsrf_secret
  xsrf_secret_key                  = local.harbor_existing_xsrf_secret_key
  admin_password_secret_name       = local.harbor_existing_admin_password
  admin_password_secret_key        = local.harbor_existing_secret_admin_password_key
  jobservice_secret_name           = local.harbor_existing_jobservice_secret
  jobservice_secret_key            = local.harbor_existing_jobservice_secret_key
  registry_secret_name             = local.harbor_existing_registry_http_secret
  registry_secret_key              = local.harbor_existing_registry_http_secret_key
  registry_credentials_secret_name = local.harbor_existing_registry_credentials_secret
  oidc_secret_name                 = local.harbor_oidc_secret
  oidc_secret_key                  = local.harbor_oidc_secret_key
  oidc_config                      = local.harbor_oidc_config

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

