# Create OIDC client secrets in gateway namespace
# Each secret contains a "client-secret" key as required by Envoy Gateway OIDC

resource "kubernetes_secret" "oidc_client_secrets" {
  for_each = var.oidc_client_secrets

  metadata {
    name      = each.key
    namespace = var.gateway_namespace
  }

  data = {
    "client-secret" = each.value
  }
}

# Deploy Chorus Gateway Helm chart

resource "helm_release" "chorus_gateway" {
  name             = "${var.cluster_name}-${var.chart_name}"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.chart_name}"
  version          = var.chart_version
  namespace        = var.gateway_namespace
  create_namespace = false
  wait             = true
  values           = [var.helm_values]

  depends_on = [kubernetes_secret.oidc_client_secrets]
}
