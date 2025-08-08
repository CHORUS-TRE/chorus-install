variable "remote_cluster_name" {
  type        = string
  description = "The name of the remote Kubernetes cluster to connect to."
}

variable "remote_cluster_server" {
  type        = string
  description = "The API server endpoint URL of the remote Kubernetes cluster."
}

variable "remote_cluster_bearer_token" {
  type        = string
  description = "The bearer token used for authentication with the remote Kubernetes cluster."
}

variable "remote_cluster_ca_data" {
  type        = string
  description = "The base64-encoded CA certificate data for verifying the remote cluster's TLS connection."
  default     = ""
}

variable "argocd_namespace" {
  description = "Namespace to deploy ArgoCD Helm chart into"
  type        = string
}