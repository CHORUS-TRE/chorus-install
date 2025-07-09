locals {
  argocd_values_parsed = yamldecode(var.argocd_helm_values)
  argocd_oidc_config   = yamldecode(local.argocd_values_parsed.argo-cd.configs.cm["oidc.config"])
  argocd_oidc_secret   = regex("\\$(.*?):", local.argocd_oidc_config.clientSecret).0
}

# Secrets

resource "kubernetes_secret" "argocd_secret" {
  metadata {
    name      = local.argocd_oidc_secret
    namespace = var.argocd_namespace
    labels = {
      "app.kubernetes.io/name"    = local.argocd_oidc_secret
      "app.kubernetes.io/part-of" = "argocd"
    }
  }

  data = {
    "keycloak.issuer"       = var.oidc_endpoint
    "keycloak.clientId"     = var.oidc_client_id
    "keycloak.clientSecret" = var.oidc_client_secret
  }
}

/*
TODO: CHECK IF WAIT IS STILL NEEDED
resource "null_resource" "wait_for_argocd_server" {
  provisioner "local-exec" {
    quiet   = true
    command = <<EOT
      set -e
      export KUBECONFIG
      kubectl config use-context ${var.kubeconfig_context}
      for i in {1..30}; do
        READY=$(kubectl get pods -n ${var.argocd_namespace} -l app.kubernetes.io/name=argocd-server -o jsonpath="{.items[0].status.containerStatuses[0].ready}")
        if [ "$READY" = "true" ]; then
          exit 0
        else
          echo "Waiting for ArgoCD gRPC API... ($i)"
          sleep 10
        fi
      done
      echo "Timed out waiting for ArgoCD gRPC API" >&2
      exit 1
    EOT
    environment = {
      KUBECONFIG = pathexpand(var.kubeconfig_path)
    }
  }
  triggers = {
    always_run = timestamp()
  }
}
*/

# AppProject and ApplicationSet

resource "helm_release" "argo_deploy" {
  name             = "${var.cluster_name}-${var.argo_deploy_chart_name}"
  repository       = "oci://${var.helm_registry}"
  chart            = "charts/${var.argo_deploy_chart_name}"
  version          = var.argo_deploy_chart_version
  namespace        = var.argocd_namespace
  create_namespace = false
  wait             = true
  values           = [var.argo_deploy_helm_values]

  depends_on = [null_resource.wait_for_argocd_server]
}