variable "namespace" {
  description = "The Kubernetes namespace where Fluent Operator is deployed"
  type        = string

  validation {
    condition     = length(var.namespace) > 0
    error_message = "namespace cannot be empty."
  }
}

variable "loki_http_user" {
  description = "HTTP basic auth username for Loki connection"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.loki_http_user) > 0
    error_message = "loki_http_user cannot be empty."
  }
}

variable "loki_http_password" {
  description = "HTTP basic auth password for Loki connection"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.loki_http_password) > 0
    error_message = "loki_http_password cannot be empty."
  }
}

variable "loki_tenant_id" {
  description = "Tenant ID for Loki multi-tenancy"
  type        = string

  validation {
    condition     = length(var.loki_tenant_id) > 0
    error_message = "loki_tenant_id cannot be empty."
  }
}
