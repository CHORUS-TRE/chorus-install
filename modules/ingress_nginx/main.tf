# Namespace

resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = var.namespace
  }
}

# Ingress-Nginx

resource "helm_release" "ingress_nginx" {
  name             = "${var.cluster_name}-${var.chart_name}"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.chart_name}"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = false
  wait             = true
  values           = [var.helm_values]

  depends_on = [kubernetes_namespace.ingress_nginx]
}

# Load Balancer

resource "null_resource" "wait_for_lb_ip" {
  provisioner "local-exec" {
    quiet       = true
    command     = <<EOT
    set -e
    export KUBECONFIG
    kubectl config use-context ${var.kubeconfig_context}
    i=0
    while [ $i -lt 30 ]; do
      IP=$(kubectl get svc ${var.cluster_name}-${var.chart_name}-controller -n ${var.namespace} -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
      if [ -n "$IP" ]; then
        exit 0
      fi
      echo "Waiting for LoadBalancer IP..."
      sleep 10
      i=$((i+1))
    done
    echo "Timed out waiting for LoadBalancer IP" >&2
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

  depends_on = [helm_release.ingress_nginx]
}

data "kubernetes_service" "loadbalancer" {
  metadata {
    name      = "${var.cluster_name}-${var.chart_name}-controller"
    namespace = var.namespace
  }

  depends_on = [null_resource.wait_for_lb_ip]
}