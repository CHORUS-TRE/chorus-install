variable "github_orga" {
  description = "GitHub organization to use repositories from"
  type        = string
  default     = "CHORUS-TRE"
}

variable "helm_values_repo" {
  description = "GitHub repository to get the Helm charts values from"
  type        = string
  default     = "environment-template"
}

variable "helm_values_pat" {
  description = "Fine-grained personal access token (PAT) to access the Helm chart values repository (e.g. CHORUS-TRE/environment-template)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "chorus_release" {
  description = "CHORUS-TRE release to use"
  type        = string
  default     = "v0.1.0-alpha"
}

variable "helm_values_path" {
  description = "Path to the local folder gathering the CHORUS Helm charts values"
  type        = string
  default     = "../../values"
}

variable "kubeconfig_context" {
  description = "Kubernetes context to use"
  type        = string
}

variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string
  default     = ""
}

variable "cert_manager_chart_name" {
  description = "Cert-Manager Helm chart name"
  type        = string
  default     = "cert-manager"
}


variable "cert_manager_crds_path" {
  description = "Path to the downloaded Cert-Manager CRDs file"
  type        = string
  default     = "../../crds"
}


variable "helm_registry" {
  description = "CHORUS Helm chart registry"
  type        = string
}

variable "helm_registry_username" {
  description = "Username to connect to the CHORUS Helm chart registry"
  type        = string
  default     = ""
}

variable "helm_registry_password" {
  description = "Password to connect to the CHORUS Helm chart registry"
  type        = string
  sensitive   = true
  default     = ""
}

variable "remote_cluster_kubeconfig_context" {
  description = "Kubernetes context to use for the remote cluster"
  type        = string
  default     = ""
}

variable "remote_cluster_name" {
  description = "The name of the remote cluster"
  type        = string
  default     = ""
}