variable "kubeconfig_path" {
  description = "Path to the Kubernetes config file"
  type        = string
}

variable "kubeconfig_context" {
  description = "Kubernetes context to use"
  type        = string
}

variable "remote_cluster_kubeconfig_path" {
  description = "Path to the Kubernetes config file for the remote cluster"
  type        = string
}

variable "remote_cluster_insecure" {
  description = "Allow insecure connection to remote cluster"
  type        = string
  default     = false
}

variable "remote_cluster_kubeconfig_context" {
  description = "Kubernetes context to use for the remote cluster"
  type        = string
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