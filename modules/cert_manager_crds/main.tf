resource "helm_release" "cert_manager_crds" {
  name             = "${var.cluster_name}-${var.chart_name}"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.chart_name}"
  version          = var.chart_version
  namespace        = var.cert_manager_namespace
  create_namespace = true
  wait             = true
  values           = var.helm_values != "" ? [var.helm_values] : []
}
