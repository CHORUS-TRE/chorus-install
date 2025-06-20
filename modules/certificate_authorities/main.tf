# Read values
locals {
  cert_manager_namespace = yamldecode(var.cert_manager_helm_values).cert-manager.namespace
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = local.cert_manager_namespace
  }
}

# Cert-Manager CRDs installation
data "http" "cert_manager_crds" {
  url = "https://github.com/cert-manager/cert-manager/releases/download/${var.cert_manager_app_version}/cert-manager.crds.yaml"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to download Cert-Manager CRDs: ${self.status_code}"
    }
  }
}

resource "kubernetes_manifest" "cert_manager_crds" {
    for_each = { for i, m in provider::kubernetes::manifest_decode_multi(data.http.cert_manager_crds.response_body) : i => m }
    manifest = each.value
    depends_on = [
      kubernetes_namespace.cert_manager,
      data.http.cert_manager_crds
    ]
}

# Cert-Manager deployment
resource "helm_release" "cert_manager" {
  name       = "${var.cluster_name}-${var.cert_manager_chart_name}"
  repository = "oci://${var.helm_registry}"
  chart      = "charts/${var.cert_manager_chart_name}"
  version    = var.cert_manager_chart_version
  namespace  = local.cert_manager_namespace
  create_namespace = false
  wait       = true
  skip_crds  = true

  values = [ var.cert_manager_helm_values ]

  depends_on = [
    kubernetes_namespace.cert_manager,
    kubernetes_manifest.cert_manager_crds
  ]
}

resource "time_sleep" "wait_for_webhook" {
  depends_on = [ helm_release.cert_manager ]

  create_duration = "60s"
}

# Self-Signed Issuer (e.g. for PostgreSQL)
resource "helm_release" "selfsigned" {
  name       = "${var.cluster_name}-${var.selfsigned_chart_name}"
  repository = "oci://${var.helm_registry}"
  chart      = "charts/${var.selfsigned_chart_name}"
  version    = var.selfsigned_chart_version
  namespace  = local.cert_manager_namespace
  create_namespace = false
  wait       = true

  values = [ var.selfsigned_helm_values ]

  depends_on = [ time_sleep.wait_for_webhook ]
}