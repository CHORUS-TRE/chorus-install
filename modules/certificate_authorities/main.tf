locals {
  cert_manager_crds_content = file(var.cert_manager_crds_path)
}
# Namespace

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = var.cert_manager_namespace
  }
}

# Cert-Manager CRDs

module "cert_manager_crds" {
  source = "../cert_manager_crds"

  cert_manager_crds_content = local.cert_manager_crds_content
}

# Cert-Manager

resource "helm_release" "cert_manager" {
  name             = "${var.cluster_name}-${var.cert_manager_chart_name}"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.cert_manager_chart_name}"
  version          = var.cert_manager_chart_version
  namespace        = var.cert_manager_namespace
  create_namespace = false
  wait             = true

  values = [var.cert_manager_helm_values]

  set {
    name  = "cert-manager.crds.enabled"
    value = "false"
  }

  depends_on = [
    kubernetes_namespace.cert_manager,
    module.cert_manager_crds
  ]
}

resource "null_resource" "wait_for_cert_manager_webhook" {
  provisioner "local-exec" {
    quiet       = true
    command     = <<EOT
      set -e
      export KUBECONFIG
      kubectl config use-context ${var.kubeconfig_context}
      i=0
      while [ $i -lt 30 ]; do
        kubectl -n ${var.cert_manager_namespace} get pod -l app.kubernetes.io/name=webhook -o jsonpath='{.items[0].status.containerStatuses[0].ready}' 2>/dev/null | grep -q true && exit 0
        sleep 5
        i=$((i+1))
      done
      echo "Timeout waiting for cert-manager webhook" >&2
      exit 1
    EOT
    interpreter = ["/bin/sh", "-c"]
    environment = {
      KUBECONFIG = pathexpand(var.kubeconfig_path)
    }
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [helm_release.cert_manager]
}

# Self-Signed Issuer (e.g. for PostgreSQL)

resource "helm_release" "selfsigned" {
  name             = "${var.cluster_name}-${var.selfsigned_chart_name}"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.selfsigned_chart_name}"
  version          = var.selfsigned_chart_version
  namespace        = var.cert_manager_namespace
  create_namespace = false
  wait             = true

  values = [var.selfsigned_helm_values]

  depends_on = [null_resource.wait_for_cert_manager_webhook]
}