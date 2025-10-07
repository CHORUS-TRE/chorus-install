locals {
  argocd_values_parsed = yamldecode(var.argocd_helm_values)
  argocd_oidc_config   = yamldecode(local.argocd_values_parsed.argo-cd.configs.cm["oidc.config"])
  # Extract key and secret name from  format: $secret-name:key-name
  # We assume all three (issuer, clientId, clientSecret) use the same secret
  keycloak_issuer_key        = regex("\\$[^:]+:(.+)", local.argocd_oidc_config.issuer)[0]
  keycloak_client_id_key     = regex("\\$[^:]+:(.+)", local.argocd_oidc_config.clientId)[0]
  keycloak_client_secret_key = regex("\\$[^:]+:(.+)", local.argocd_oidc_config.clientSecret)[0]
  argocd_oidc_secret_name    = regex("\\$([^:]+):", local.argocd_oidc_config.clientSecret)[0]
}

# Secrets

resource "kubernetes_secret" "argocd_secret" {
  metadata {
    name      = local.argocd_oidc_secret_name
    namespace = var.argocd_namespace
    labels = {
      "app.kubernetes.io/name"    = local.argocd_oidc_secret_name
      "app.kubernetes.io/part-of" = "argocd"
    }
  }

  data = {
    "${local.keycloak_issuer_key}"  = var.oidc_endpoint
    "${keycloak_client_id_key}"     = var.oidc_client_id
    "${keycloak_client_secret_key}" = var.oidc_client_secret
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