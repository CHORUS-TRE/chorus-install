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