variable "chorusci_namespace" {
  description = "Namespace where ChorusCI is deployed"
  type        = string
}

variable "chorusci_helm_values" {
  description = "ChorusCI Helm chart values"
  type        = string
}

variable "github_workbench_operator_token" {
  description = "GitHub token for the Workbench Operator repository"
  type        = string
  sensitive   = true
}

variable "github_chorus_web_ui_token" {
  description = "GitHub token for the Chorus Web UI repository"
  type        = string
  sensitive   = true
}

variable "github_images_token" {
  description = "GitHub token for the Images repository"
  type        = string
  sensitive   = true
}

variable "github_chorus_backend_token" {
  description = "GitHub token for the Chorus Backend repository"
  type        = string
  sensitive   = true
}

variable "github_username" {
  description = "GitHub username for Argo Workflows to use"
  type        = string
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
