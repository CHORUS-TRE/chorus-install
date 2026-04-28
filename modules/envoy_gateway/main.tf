# Namespace

resource "kubernetes_namespace" "gateway" {
  metadata {
    name = var.gateway_namespace
  }
}

# Gateway API CRDs

resource "helm_release" "gateway_crds" {
  name             = "${var.cluster_name}-${var.gateway_crds_chart_name}"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.gateway_crds_chart_name}"
  version          = var.gateway_crds_chart_version
  namespace        = var.gateway_namespace
  create_namespace = false
  wait             = true
  values           = var.gateway_crds_helm_values != "" ? [var.gateway_crds_helm_values] : []

  depends_on = [kubernetes_namespace.gateway]
}

# Gateway (EnvoyProxy, GatewayClass, Gateway resources)

resource "helm_release" "gateway" {
  name             = "${var.cluster_name}-${var.gateway_chart_name}"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.gateway_chart_name}"
  version          = var.gateway_chart_version
  namespace        = var.gateway_namespace
  create_namespace = false
  wait             = true
  values           = [var.gateway_helm_values]

  depends_on = [
    kubernetes_namespace.gateway,
    helm_release.gateway_crds
  ]
}

# Wait for Gateway LoadBalancer IP

resource "null_resource" "wait_for_gateway_lb_ip" {
  provisioner "local-exec" {
    quiet       = true
    command     = <<EOT
    set -e
    export KUBECONFIG
    kubectl config use-context ${var.kubeconfig_context}

    i=0
    while [ $i -lt 60 ]; do
      IP=$(kubectl get gateway -n ${var.gateway_namespace} -o jsonpath='{.items[0].status.addresses[0].value}' 2>/dev/null || echo "")
      if [ -n "$IP" ]; then
        echo "Gateway LoadBalancer IP: $IP"
        exit 0
      fi
      echo "Waiting for Gateway LoadBalancer IP..."
      sleep 10
      i=$((i+1))
    done
    echo "Timed out waiting for Gateway LoadBalancer IP" >&2
    exit 1
    EOT
    interpreter = ["/bin/sh", "-c"]
    environment = {
      KUBECONFIG = pathexpand(var.kubeconfig_path)
    }
  }

  triggers = {
    gateway_version = var.gateway_chart_version
    gateway_values  = md5(var.gateway_helm_values)
  }

  depends_on = [helm_release.gateway]
}

# Data source to fetch LoadBalancer service IP

data "kubernetes_service" "gateway_envoy" {
  metadata {
    name      = "envoy-gateway-system"
    namespace = var.gateway_namespace
  }

  depends_on = [null_resource.wait_for_gateway_lb_ip]
}
