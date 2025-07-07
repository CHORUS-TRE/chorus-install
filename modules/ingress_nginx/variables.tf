variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string
}

variable "helm_registry" {
  description = "Helm chart registry to get the chart from"
  type        = string
}

variable "chart_name" {
  description = "Ingress-Nginx Helm chart name"
  type        = string
}

variable "chart_version" {
  description = "Ingress-Nginx Helm chart version"
  type        = string
}

variable "helm_values" {
  description = "Ingress-Nginx Helm chart values"
  type        = string
}

variable "namespace" {
  description = "Namespace to deploy Ingress-Nginx Helm chart into"
  type        = string
}

variable "kubeconfig_path" {
  description = "Path to the Kubernetes config file"
  type        = string
}

variable "kubeconfig_context" {
  description = "Kubernetes context to use"
  type        = string
}