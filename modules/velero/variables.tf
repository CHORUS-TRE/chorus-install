variable "namespace" {
  description = "Velero's Kubernetes namespace name"
  type        = string

  validation {
    condition     = length(var.namespace) > 0
    error_message = "namespace cannot be empty."
  }
}

variable "credentials_secret_name" {
  description = "Name of the Kubernetes secret to store Velero S3 credentials"
  type        = string

  validation {
    condition     = length(var.credentials_secret_name) > 0
    error_message = "credentials_secret_name cannot be empty."
  }
}

variable "access_key_id" {
  description = "S3 access key ID for Velero backup storage"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.access_key_id) > 0
    error_message = "access_key_id cannot be empty."
  }
}

variable "secret_access_key" {
  description = "S3 secret access key for Velero backup storage"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.secret_access_key) > 0
    error_message = "secret_access_key cannot be empty."
  }
}
