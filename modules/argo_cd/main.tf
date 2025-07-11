locals {
  argocd_values_parsed             = yamldecode(var.argocd_helm_values)
  argocd_cache_values_parsed       = yamldecode(var.argocd_cache_helm_values)
  argocd_cache_existing_secret     = local.argocd_cache_values_parsed.valkey.auth.existingSecret
  argocd_cache_existing_secret_key = local.argocd_cache_values_parsed.valkey.auth.existingSecretPasswordKey
}

# Namespace

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
  }
}

# Secrets

resource "random_password" "redis_password" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "argocd_cache" {
  metadata {
    name      = local.argocd_cache_existing_secret
    namespace = var.argocd_namespace
  }

  data = {
    # TODO: double check why user is empty string (copied from chorus-build)
    "redis-username"                            = ""
    "${local.argocd_cache_existing_secret_key}" = random_password.redis_password.result
  }

  depends_on = [kubernetes_namespace.argocd]
}

resource "kubernetes_secret" "environments_repository_credentials" {
  metadata {
    name      = var.helm_charts_values_credentials_secret
    namespace = var.argocd_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    url      = var.helm_values_url
    password = var.helm_values_pat
    type     = "git"
  }

  depends_on = [kubernetes_namespace.argocd]
}

# The following secret name is hardcoded 
# because ArgoCD relies only on the labels

resource "kubernetes_secret" "oci-build" {
  metadata {
    name      = "oci-repository-build"
    namespace = var.argocd_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    enableOCI = "true"
    name      = "chorus-build-harbor"
    password  = var.harbor_robot_password
    type      = "helm"
    url       = var.harbor_domain
    username  = join("", ["robot$", var.harbor_robot_username])
  }

  depends_on = [kubernetes_namespace.argocd]
}

/*
# Note: in-cluster is created by default in ArgoCD
Remote cluster configuration will be done in a second development round

resource "kubernetes_secret" "remote_cluster" {
  metadata {
    name = TODO
    namespace = var.argocd_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }

    data = {
      name = TODO
      server = TODO
      config = TODO
    }
  }
}
IDEA: take the path to the config.json file as module input,
read the file in the locals block at the top of this file and
inject it in the secret

{
  "bearerToken": "<token>",
  "tlsClientConfig": {
    "insecure": false,
    "caData": "<base64-encoded-ca-cert>"
  }
}

*/

# ArgoCD Cache (Valkey)

resource "helm_release" "argocd_cache" {
  name             = "${var.cluster_name}-${var.argocd_chart_name}-cache"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.argocd_cache_chart_name}"
  version          = var.argocd_cache_chart_version
  namespace        = var.argocd_namespace
  create_namespace = false
  wait             = true
  values           = [var.argocd_cache_helm_values]

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
    kubernetes_namespace.argocd,
    kubernetes_secret.argocd_cache
  ]
}

# ArgoCD

resource "helm_release" "argocd" {
  name             = "${var.cluster_name}-${var.argocd_chart_name}"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.argocd_chart_name}"
  version          = var.argocd_chart_version
  namespace        = var.argocd_namespace
  create_namespace = false
  wait             = true
  skip_crds        = false
  values           = [var.argocd_helm_values]

  depends_on = [
    kubernetes_namespace.argocd,
    helm_release.argocd_cache
  ]
}

# Retrieve data for outputs

data "kubernetes_secret" "argocd_admin_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = var.argocd_namespace
  }

  depends_on = [helm_release.argocd]
}