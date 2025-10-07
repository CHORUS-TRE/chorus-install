variable "webex_secret_name" {
  description = "The name of the Kubernetes Secret to create for Webex integration"
  type        = string
}

variable "webex_secret_key" {
  description = "The key of the Kubernetes Secret to create for Webex integration"
  type        = string
}

variable "alertmanager_namespace" {
  description = "The namespace where the Alertmanager Webex Secret should be created"
  type        = string
}

variable "webex_access_token" {
  description = "The Webex access token for the Alertmanager integration"
  type        = string
  sensitive   = true
}