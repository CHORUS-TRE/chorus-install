variable "namespace" {
  description = "The existing Kubernetes namespace where Loki is deployed (e.g. prometheus)"
  type        = string

  validation {
    condition     = length(var.namespace) > 0
    error_message = "namespace cannot be empty."
  }
}

variable "loki_clients" {
  description = "List of Loki client names for basic auth"
  type = list(object({
    name = string
  }))

  validation {
    condition     = length(var.loki_clients) > 0
    error_message = "loki_clients list cannot be empty."
  }

  validation {
    condition     = alltrue([for client in var.loki_clients : length(client.name) > 0])
    error_message = "All client names must be non-empty."
  }
}

variable "s3_access_key_id" {
  description = "S3 access key ID for Loki storage"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.s3_access_key_id) > 0
    error_message = "s3_access_key_id cannot be empty."
  }
}

variable "s3_secret_access_key" {
  description = "S3 secret access key for Loki storage"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.s3_secret_access_key) > 0
    error_message = "s3_secret_access_key cannot be empty."
  }
}
