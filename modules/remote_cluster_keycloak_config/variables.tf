variable "admin_id" {
  description = "Keycloak admin ID"
  type        = string

  validation {
    condition     = length(var.admin_id) > 0
    error_message = "admin_id cannot be empty."
  }
}

variable "infra_realm_name" {
  description = "Keycloak infrastructure realm name"
  type        = string

  validation {
    condition     = length(var.infra_realm_name) > 0
    error_message = "infra_realm_name cannot be empty."
  }
}

variable "backend_realm_name" {
  description = "Keycloak chorus backend realm name"
  type        = string

  validation {
    condition     = length(var.backend_realm_name) > 0
    error_message = "backend_realm_name cannot be empty."
  }
}

variable "google_identity_provider_client_id" {
  description = "The Google client identifier"
  type        = string
  default     = ""
}

variable "google_identity_provider_client_secret" {
  description = "The Google client secret used for authentication"
  type        = string
  sensitive   = true
  default     = ""
}