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
  default     = null
}

variable "chorus_release" {
  description = "CHORUS-TRE release to use"
  type        = string
  default     = "v0.1.0-alpha"
}

variable "helm_values_path" {
  description = "Path to the local folder gathering the CHORUS Helm charts values"
  type        = string
  default     = "../values"
}

variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string
}

variable "cert_manager_chart_name" {
  description = "Cert-Manager Helm chart name"
  type        = string
  default     = "cert-manager"
}

variable "cert_manager_crds_path" {
  description = "Path to the downloaded Cert-Manager CRDs file"
  type        = string
  default     = "../crds/cert-manager.crds.yaml"
}

variable "helm_registry" {
  description = "CHORUS Helm chart registry"
  type        = string
}

variable "helm_registry_username" {
  description = "Username to connect to the CHORUS Helm chart registry"
  type        = string
}

variable "helm_registry_password" {
  description = "Password to connect to the CHORUS Helm chart registry"
  type        = string
  sensitive   = true
}