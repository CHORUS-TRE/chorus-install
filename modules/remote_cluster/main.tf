# TODO: create all secrets needed for e.g. chorus-dev, chorus-int, chorus-qa, ...
# Plan: call this module for each remote cluster

locals {
    # TODO: read from values.yaml files
 keycloak_namespace = "keycloak"
 keycloak_existing_secret = "keycloak-secret"
 keycloak_password_secret_key = "adminPassword"
 keycloak_db_existing_secret = "keycloak_db_secret"
 keycloak_db_admin_password_key = "postgres-password"
 keycloak_db_user_password_key = "password"
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

  namespace = local.keycloak_namespace
  secret_name = local.keycloak_db_existing_secret
  db_user_password_key = local.keycloak_db_user_password_key
  db_admin_password_key = local.keycloak_db_admin_password_key

  depends_on = [kubernetes_namespace.keycloak]
}

module "keycloak_secret" {
  source = "../keycloak_secret"

  namespace = local.keycloak_namespace
  secret_name = local.keycloak_existing_secret
  secret_key = local.keycloak_password_secret_key

  depends_on = [kubernetes_namespace.keycloak]
}

# Harbor



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

