variable "harbor_helm_values" {
  description = "Harbor Helm chart values"
  type        = string
}

variable "release_desc" {
  description = "Description of all the charts and container images being part of the release"
  type = string
}

variable "source_helm_registry" {
  description = "Source Helm chart registry"
  type = string
}

variable "source_helm_registry_username" {
  description = "Username to connect to the source Helm chart registry"
  type = string
}

variable "source_helm_registry_password" {
  description = "Password to connect to the source Helm chart registry"
  type        = string
  sensitive   = true
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