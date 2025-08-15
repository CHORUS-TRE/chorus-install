locals {
  cluster_name        = coalesce(var.cluster_name, var.kubeconfig_context)
  remote_cluster_name = coalesce(var.remote_cluster_name, var.remote_cluster_kubeconfig_context)
}

module "build_cluster_helm_charts_values" {
  source = "../modules/helm_charts_values"

  cluster_name = local.cluster_name

  helm_registry           = var.helm_registry
  chorus_release          = var.chorus_release
  github_orga             = var.github_orga
  helm_values_path        = var.helm_values_path
  cert_manager_chart_name = var.cert_manager_chart_name
  helm_registry_username  = var.helm_registry_username
  helm_registry_password  = var.helm_registry_password
  cert_manager_crds_path  = var.cert_manager_crds_path
  helm_values_repo        = var.helm_values_repo
  helm_values_pat         = var.helm_values_pat
}

module "remote_cluster_helm_charts_values" {
  source = "../modules/helm_charts_values"

  cluster_name = local.remote_cluster_name

  helm_registry           = var.helm_registry
  chorus_release          = var.chorus_release
  github_orga             = var.github_orga
  helm_values_path        = var.helm_values_path
  cert_manager_chart_name = var.cert_manager_chart_name
  helm_registry_username  = var.helm_registry_username
  helm_registry_password  = var.helm_registry_password
  cert_manager_crds_path  = var.cert_manager_crds_path
  helm_values_repo        = var.helm_values_repo
  helm_values_pat         = var.helm_values_pat

  # Wait to avoid potential git conflicts
  depends_on = [module.build_cluster_helm_charts_values]
}