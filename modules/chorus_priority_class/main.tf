# CHORUS Priority Class

resource "helm_release" "chorus_priority_class" {
  name             = "${var.cluster_name}-${var.chart_name}"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.chart_name}"
  version          = var.chart_version
  namespace        = "default"
  create_namespace = false
  wait             = true
  # using default values for priority class

  depends_on = [kubernetes_namespace.chorus_priority_class]
}
