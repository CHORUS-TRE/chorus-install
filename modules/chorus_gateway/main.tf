# Create OIDC client secrets in gateway namespace
# Each secret contains a "client-secret" key as required by Envoy Gateway OIDC

module "chorus_gateway" {
  source = "../chorus_gateway_secret"

  gateway_namespace = var.gateway_namespace

  oidc_client_secrets = {
    "prometheus-oidc-secret"        = module.keycloak_secret.prometheus_client_secret
    "alertmanager-oidc-secret"      = module.keycloak_secret.alertmanager_client_secret
    "juicefs-dashboard-oidc-secret" = module.keycloak_secret.juicefs_dashboard_client_secret
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
}
