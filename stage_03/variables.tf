variable "remote_clusters_kubeconfig_path" {
  description = "Path to the Kubernetes config file for the remote clusters"
  type        = list(string)
  default     = []
}

variable "helm_values_path" {
  description = "Path to the repository storing the Helm chart values"
  type        = string
  default     = "../values"
}

variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string
}

variable "argocd_chart_name" {
  description = "ArgoCD Helm chart name"
  type        = string
  default     = "argo-cd"
}