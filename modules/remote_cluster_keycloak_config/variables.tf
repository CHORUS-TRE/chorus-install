variable "admin_id" {
  description = "Keycloak admin ID"
  type        = string
}

variable "infra_realm_name" {
  description = "Keycloak infrastructure realm name"
  type        = string
}

variable "backend_realm_name" {
  description = "Keycloak chorus backend realm name"
  type        = string
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