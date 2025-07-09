locals {
  argocd_values_parsed = yamldecode(var.argocd_helm_values)
  argocd_oidc_config   = yamldecode(local.argocd_values_parsed.argo-cd.configs.cm["oidc.config"])
  argocd_oidc_secret   = regex("\\$(.*?):", local.argocd_oidc_config.clientSecret).0
}

# Secrets

resource "kubernetes_secret" "argocd_secret" {
  metadata {
    name      = local.argocd_oidc_secret
    namespace = var.argocd_namespace
    labels = {
      "app.kubernetes.io/name"    = local.argocd_oidc_secret
      "app.kubernetes.io/part-of" = "argocd"
    }
  }

  data = {
    "keycloak.issuer"       = var.oidc_endpoint
    "keycloak.clientId"     = var.oidc_client_id
    "keycloak.clientSecret" = var.oidc_client_secret
  }
}

# AppProject and ApplicationSet

resource "helm_release" "argo_deploy" {
  name             = "${var.cluster_name}-${var.argo_deploy_chart_name}"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.argo_deploy_chart_name}"
  version          = var.argo_deploy_chart_version
  namespace        = var.argocd_namespace
  create_namespace = false
  wait             = true
  values           = [var.argo_deploy_helm_values]
}