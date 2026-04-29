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
