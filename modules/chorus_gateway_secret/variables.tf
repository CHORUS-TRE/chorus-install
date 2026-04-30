variable "gateway_namespace" {
  description = "Namespace where Gateway is deployed (where OIDC secrets will be created)"
  type        = string

  validation {
    condition     = length(var.gateway_namespace) > 0
    error_message = "gateway_namespace cannot be empty."
  }
}

variable "oidc_client_secrets" {
  description = "Map of OIDC client secrets to create in the gateway namespace. Key is secret name, value is the client secret."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.oidc_client_secrets : length(k) > 0 && length(v) > 0])
    error_message = "All OIDC client secret names and values must be non-empty."
  }
}
