variable "webex_secret_name" {
  description = "The name of the Kubernetes Secret to create for Webex integration"
  type        = string

  validation {
    condition     = length(var.webex_secret_name) > 0
    error_message = "webex_secret_name cannot be empty."
  }
}

variable "webex_secret_key" {
  description = "The key of the Kubernetes Secret to create for Webex integration"
  type        = string

  validation {
    condition     = length(var.webex_secret_key) > 0
    error_message = "webex_secret_key cannot be empty."
  }
}

variable "alertmanager_namespace" {
  description = "The namespace where the Alertmanager Webex Secret should be created"
  type        = string

  validation {
    condition     = length(var.alertmanager_namespace) > 0
    error_message = "alertmanager_namespace cannot be empty."
  }
}

variable "webex_access_token" {
  description = "The Webex access token for the Alertmanager integration"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.webex_access_token) > 0
    error_message = "webex_access_token cannot be empty."
  }
}