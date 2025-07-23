variable "argoci_namespace" {
  description = "Namespace where ArgoCI is deployed"
  type        = string
}

variable "argoci_helm_values" {
  description = "ArgoCI Helm chart values"
  type        = string
}

variable "argoci_github_workbench_operator_token" {
  description = "GitHub token for the Workbench Operator repository"
  type        = string
  sensitive   = true
}

variable "argoci_github_chorus_web_ui_token" {
  description = "GitHub token for the Chorus Web UI repository"
  type        = string
  sensitive   = true
}

variable "argoci_github_images_token" {
  description = "GitHub token for the Images repository"
  type        = string
  sensitive   = true
}

variable "argoci_github_chorus_backend_token" {
  description = "GitHub token for the Chorus Backend repository"
  type        = string
  sensitive   = true
}

variable "registry_server" {
  description = "The container registry server (e.g. Harbor)"
  type        = string
}

variable "registry_username" {
  description = "The robot username for the container registry"
  type        = string
}

variable "registry_password" {
  description = "The robot password for the container registry"
  type        = string
  sensitive   = true
}
