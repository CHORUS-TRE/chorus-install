# Read values
locals {
  ingress_nginx_namespace = yamldecode(var.helm_values).namespaceOverride
}

# Namespace Definitions
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = local.ingress_nginx_namespace
  }
}

# Ingress-Nginx Deployment
resource "helm_release" "ingress_nginx" {
  name       = "${var.cluster_name}-${var.chart_name}"
  repository = "oci://${var.helm_registry}"
  chart      = "charts/${var.chart_name}"
  version    = var.chart_version
  namespace  = local.ingress_nginx_namespace
  create_namespace = false
  wait       = true
  values = [ var.helm_values ]

  depends_on = [ kubernetes_namespace.ingress_nginx ]
}

resource "null_resource" "wait_for_lb_ip" {
  depends_on = [ helm_release.ingress_nginx ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    quiet = true
    command = <<EOT
    set -e
    export KUBECONFIG
    kubectl config use-context ${var.kubeconfig_context}
    for i in {1..30}; do
      IP=$(kubectl get svc ${var.cluster_name}-${var.chart_name}-controller -n ${local.ingress_nginx_namespace} -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
      if [ ! -z $IP ]; then
        exit 0
      fi
      echo "Waiting for LoadBalancer IP..."
      sleep 10
    done
    echo "Timed out waiting for LoadBalancer IP" >&2
    exit 1
    EOT
    environment = {
      KUBECONFIG = pathexpand(var.kubeconfig_path)
    }
  }
}

data "kubernetes_service" "loadbalancer" {
  metadata {
    name = "${var.cluster_name}-${var.chart_name}-controller"
    namespace = local.ingress_nginx_namespace
  }

  depends_on = [ null_resource.wait_for_lb_ip ]
}

output "loadbalancer_ip" {
  value = data.kubernetes_service.loadbalancer.status.0.load_balancer.0.ingress.0.ip
  depends_on = [ null_resource.wait_for_lb_ip ]
}