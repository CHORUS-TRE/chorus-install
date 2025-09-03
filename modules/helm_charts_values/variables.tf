variable "github_orga" {
  description = "GitHub organization to use repositories from"
  type        = string
}

variable "helm_values_repo" {
  description = "The Git repository URL containing Helm values files for deployments"
  type        = string
}

variable "helm_values_path" {
  description = "The local file system path where Helm values are stored"
  type        = string
}

variable "helm_values_pat" {
  description = "The Personal Access Token (PAT) used to authenticate with the Helm values Git repository"
  type        = string
  sensitive   = true
}

variable "chorus_release" {
  description = "The Chorus release identifier"
  type        = string
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster where resources will be deployed"
  type        = string
}

variable "cert_manager_chart_name" {
  description = "The name of the Cert-Manager Helm chart (or wrapper chart) to deploy"
  type        = string
}

variable "helm_registry" {
  description = "The OCI registry URL hosting the Helm charts"
  type        = string
}

variable "helm_registry_username" {
  description = "The username for authenticating with the Helm chart registry"
  type        = string
}

variable "helm_registry_password" {
  description = "The password for authenticating with the Helm chart registry"
  type        = string
  sensitive   = true
}

variable "cert_manager_crds_path" {
  description = "The local file system path to the downloaded Cert-Manager CRDs YAML file"
  type        = string
}