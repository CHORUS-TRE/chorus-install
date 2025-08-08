# TODO: create all secrets needed for e.g. chorus-dev, chorus-int, chorus-qa, ...
# Plan: call this module for each remote cluster


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

locals {
  cluster_config = jsonencode({
    bearerToken = var.remote_cluster_bearer_token
    tlsClientConfig = {
      insecure = false
      caData   = var.remote_cluster_ca_data
    }
  })
}

# Remote Cluster Connection for ArgoCD

resource "kubernetes_secret" "remote_clusters" {
  metadata {
    name      = "${local.cluster_config.name}-cluster"
    namespace = var.argocd_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }

  data = {
    name   = var.remote_cluster_name
    server = var.remote_cluster_server
    config = local.cluster_config
  }

  depends_on = [kubernetes_namespace.argocd]
}