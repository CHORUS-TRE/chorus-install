# Create OIDC client secrets in gateway namespace
# Each secret contains a "client-secret" key as required by Envoy Gateway OIDC

module "chorus_gateway" {
  source = "../chorus_gateway_secret"

  gateway_namespace = var.gateway_namespace
  oidc_client_secrets = var.oidc_client_secrets
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
}
