variable "github_orga" {
  description = "GitHub organization to use repositories from"
  type = string
  default = "CHORUS-TRE"
}

variable "helm_values_repo" {
  description = "GitHub repository to get the Helm charts values from"
  type = string
  default = "environment-template"
}

variable "helm_values_revision" {
  description = "Helm charts values repository revision"
  type = string
  default = "HEAD"
}

variable "helm_charts_path" {
  description = "Path to the local folder gathering the CHORUS Helm charts"
  type        = string
  default     = "../charts"
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