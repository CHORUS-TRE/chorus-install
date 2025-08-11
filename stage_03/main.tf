locals {
  argocd_namespace = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/config.json")).namespace
  remote_cluster_c5t_index = index(yamldecode(file(var.remote_cluster_kubeconfig_path)).contexts.*.name, var.remote_cluster_kubeconfig_context)
  remote_cluster_name = yamldecode(file(var.remote_cluster_kubeconfig_path)).contexts[local.remote_cluster_c5t_index].name
  remote_cluster_user = yamldecode(file(var.remote_cluster_kubeconfig_path)).contexts[local.remote_cluster_c5t_index].context.user 
  remote_cluster_c5r_index = index(yamldecode(file(var.remote_cluster_kubeconfig_path)).clusters.*.name, local.remote_cluster_name)
  remote_cluster_server = yamldecode(file(var.remote_cluster_kubeconfig_path)).clusters[local.remote_cluster_c5r_index].name
  remote_cluster_u2r_index = index(yamldecode(file(var.remote_cluster_kubeconfig_path)).users.*.name, local.remote_cluster_user)
  remote_cluster_bearer_token = yamldecode(file(var.remote_cluster_kubeconfig_path)).users[local.remote_cluster_u2r_index].user.token 
  remote_cluster_ca_data = yamldecode(file(var.remote_cluster_kubeconfig_path)).clusters[local.remote_cluster_c5r_index].cluster["certificate-authority-data"]

  remote_cluster_config = jsonencode({
    bearerToken = local.remote_cluster_bearer_token
    tlsClientConfig = {
      insecure = var.remote_cluster_insecure
      caData   = local.remote_cluster_ca_data
    }
  })
}

# Remote Cluster Connection for ArgoCD

resource "kubernetes_secret" "remote_clusters" {
  metadata {
    name      = "${local.remote_cluster_name}-cluster"
    namespace = local.argocd_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }

  data = {
    name   = local.remote_cluster_name
    server = local.remote_cluster_server
    config = local.remote_cluster_config
  }
}

provider "kubernetes" {
  alias          = "remote_cluster"
  config_path    = var.remote_cluster_kubeconfig_path
  config_context = var.remote_cluster_kubeconfig_context
}

module "remote_cluster" {
  source = "../modules/remote_cluster"
  
  providers = {
    kubernetes = kubernetes.remote_cluster
  }
}