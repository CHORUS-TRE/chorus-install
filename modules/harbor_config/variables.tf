variable "harbor_helm_values" {
  description = "Harbor Helm chart values"
  type        = string

  validation {
    condition     = length(var.harbor_helm_values) > 0
    error_message = "harbor_helm_values cannot be empty."
  }

  validation {
    condition     = can(yamldecode(var.harbor_helm_values))
    error_message = "harbor_helm_values must be valid YAML."
  }
}

variable "charts_versions" {
  description = "Map holding each chart and its version to upload to Harbor"
  type        = map(list(string))

  validation {
    condition     = length(var.charts_versions) > 0
    error_message = "charts_versions cannot be empty."
  }
}

variable "source_helm_registry" {
  description = "Source Helm chart registry"
  type        = string

  validation {
    condition     = length(var.source_helm_registry) > 0
    error_message = "source_helm_registry cannot be empty."
  }
}

variable "source_helm_registry_username" {
  description = "Username to connect to the source Helm chart registry"
  type        = string

  validation {
    condition     = length(var.source_helm_registry_username) > 0
    error_message = "source_helm_registry_username cannot be empty."
  }
}

variable "source_helm_registry_password" {
  description = "Password to connect to the source Helm chart registry"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.source_helm_registry_password) > 0
    error_message = "source_helm_registry_password cannot be empty."
  }
}

variable "github_actions_robot_username" {
  description = "Username of the robot to be used by GitHub Actions"
  type        = string

  validation {
    condition     = length(var.github_actions_robot_username) > 0
    error_message = "github_actions_robot_username cannot be empty."
  }
}

variable "argocd_robot_username" {
  description = "Username of the robot to be used by ArgoCD"
  type        = string

  validation {
    condition     = length(var.argocd_robot_username) > 0
    error_message = "argocd_robot_username cannot be empty."
  }
}

variable "chorusci_robot_username" {
  description = "Username of the robot to be used by ChorusCI"
  type        = string

  validation {
    condition     = length(var.chorusci_robot_username) > 0
    error_message = "chorusci_robot_username cannot be empty."
  }
}

variable "renovate_robot_username" {
  description = "Username of the robot to be used by Renovate"
  type        = string

  validation {
    condition     = length(var.renovate_robot_username) > 0
    error_message = "renovate_robot_username cannot be empty."
  }
}

variable "harbor_admin_username" {
  description = "Harbor admin username"
  type        = string

  validation {
    condition     = length(var.harbor_admin_username) > 0
    error_message = "harbor_admin_username cannot be empty."
  }
}

variable "harbor_admin_password" {
  description = "Harbor admin password"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.harbor_admin_password) > 0
    error_message = "harbor_admin_password cannot be empty."
  }
}