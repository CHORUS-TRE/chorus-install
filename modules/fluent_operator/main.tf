resource "kubernetes_namespace" "fluent_operator" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "loki_client_credentials" {
  metadata {
    name      = "loki-client-credentials"
    namespace = var.namespace
  }

  data = {
    httpUser     = var.loki_http_user
    httpPassword = var.loki_http_password
    tenantID     = var.loki_tenant_id
  }

  type = "Opaque"

  depends_on = [kubernetes_namespace.fluent_operator]
}
