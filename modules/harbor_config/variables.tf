variable "harbor_helm_values" {
  description = "Harbor Helm chart values"
  type        = string
}

variable "charts_versions" {
  description = "Map holding each chart and its version to upload to Harbor"
  type        = map(list(string))
}

variable "source_helm_registry" {
  description = "Source Helm chart registry"
  type        = string
}

variable "source_helm_registry_username" {
  description = "Username to connect to the source Helm chart registry"
  type        = string
}

variable "source_helm_registry_password" {
  description = "Password to connect to the source Helm chart registry"
  type        = string
  sensitive   = true
}

variable "github_actions_robot_username" {
  description = "Username of the robot to be used by GitHub Actions"
  type        = string
}

variable "argocd_robot_username" {
  description = "Username of the robot to be used by ArgoCD"
  type        = string
}

variable "argoci_robot_username" {
  description = "Username of the robot to be used by ArgoCI"
  type        = string
}

variable "harbor_admin_username" {
  description = "Harbor admin username"
  type        = string
}

variable "harbor_admin_password" {
  description = "Harbor admin password"
  type        = string
  sensitive   = true
}