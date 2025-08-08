locals {
  argocd_namespace = jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/config.json")).namespace
  remote_clusters_config = flatten([
    for kubeconfig_path in var.remote_clusters_kubeconfig_path : [
      for context in yamldecode(file(kubeconfig_path)).contexts : {
        name         = context.name
        server       = yamldecode(file(kubeconfig_path)).clusters[index(yamldecode(file(kubeconfig_path)).clusters.*.name, context.context.cluster)].cluster.server
        bearer_token = yamldecode(file(kubeconfig_path)).users[index(yamldecode(file(kubeconfig_path)).users.*.name, context.context.user)].user.token
        ca_data      = yamldecode(file(kubeconfig_path)).clusters[index(yamldecode(file(kubeconfig_path)).clusters.*.name, context.context.cluster)].cluster["certificate-authority-data"]
      }
    ]
  ])
}

module "remote_cluster" {
  source = "../modules/remote_cluster"

  argocd_namespace            = local.argocd_namespace
  remote_cluster_name         = each.value.name
  remote_cluster_server       = each.value.server
  remote_cluster_bearer_token = each.value.bearer_token
  remote_cluster_ca_data      = each.value.ca_data

  for_each = { for cluster in local.remote_clusters_config : cluster.name => cluster }
}