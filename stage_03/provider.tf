provider "kubernetes" {
  config_path    = var.remote_cluster_kubeconfig_path
  config_context = var.remote_cluster_kubeconfig_context
}