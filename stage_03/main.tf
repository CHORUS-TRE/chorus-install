locals {
  argocd_namespace = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/config.json")).namespace
  remote_cluster_config = {
    name         = var.remote_cluster_kubeconfig_context
    server       = yamldecode(file(var.remote_cluster_kubeconfig_path)).clusters[index(yamldecode(file(var.remote_cluster_kubeconfig_path)).clusters.*.name, var.remote_cluster_kubeconfig_context)].cluster.server
    bearer_token = yamldecode(file(var.remote_cluster_kubeconfig_path)).users[index(yamldecode(file(var.remote_cluster_kubeconfig_path)).users.*.name, var.remote_cluster_kubeconfig_context)].user.token
    ca_data      = yamldecode(file(var.remote_cluster_kubeconfig_path)).clusters[index(yamldecode(file(var.remote_cluster_kubeconfig_path)).clusters.*.name, var.remote_cluster_kubeconfig_context)].cluster["certificate-authority-data"]
  }
  remote_cluster_config_encoded = jsonencode({
    bearerToken = local.remote_cluster_config
    tlsClientConfig = {
      insecure = var.remote_cluster_insecure
      caData   = local.remote_cluster_config.ca_data
    }
  })
}

# Remote Cluster Connection for ArgoCD

resource "kubernetes_secret" "remote_clusters" {
  metadata {
    name      = "${local.remote_cluster_config.name}-cluster"
    namespace = local.argocd_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }

  data = {
    name   = local.remote_cluster_config.name
    server = local.remote_cluster_config.server
    config = local.remote_cluster_config_encoded
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