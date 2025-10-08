variable "cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster where JuiceFS will be deployed."

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "cluster_name cannot be empty."
  }
}

variable "juicefs_cache_secret_name" {
  type        = string
  description = "Name of the Kubernetes Secret used for JuiceFS cache credentials."

  validation {
    condition     = length(var.juicefs_cache_secret_name) > 0
    error_message = "juicefs_cache_secret_name cannot be empty."
  }
}

variable "juicefs_cache_secret_key" {
  type        = string
  description = "Key of the Kubernetes Secret used for JuiceFS cache credentials."

  validation {
    condition     = length(var.juicefs_cache_secret_key) > 0
    error_message = "juicefs_cache_secret_key cannot be empty."
  }
}

variable "juicefs_cache_namespace" {
  type        = string
  description = "Namespace where the JuiceFS cache is located."

  validation {
    condition     = length(var.juicefs_cache_namespace) > 0
    error_message = "juicefs_cache_namespace cannot be empty."
  }
}

variable "juicefs_dashboard_secret_name" {
  type        = string
  description = "Name of the Kubernetes Secret containing JuiceFS dashboard credentials."

  validation {
    condition     = length(var.juicefs_dashboard_secret_name) > 0
    error_message = "juicefs_dashboard_secret_name cannot be empty."
  }
}

variable "juicefs_csi_driver_namespace" {
  type        = string
  description = "Namespace where the JuiceFS CSI driver is deployed."

  validation {
    condition     = length(var.juicefs_csi_driver_namespace) > 0
    error_message = "juicefs_csi_driver_namespace cannot be empty."
  }
}

variable "juicefs_dashboard_username" {
  type        = string
  description = "Username used to authenticate to the JuiceFS dashboard."

  validation {
    condition     = length(var.juicefs_dashboard_username) > 0
    error_message = "juicefs_dashboard_username cannot be empty."
  }
}

variable "s3_access_key" {
  type        = string
  description = "Access key for the S3-compatible object storage."
  sensitive   = true

  validation {
    condition     = length(var.s3_access_key) > 0
    error_message = "s3_access_key cannot be empty."
  }
}

variable "s3_secret_key" {
  type        = string
  description = "Secret key for the S3-compatible object storage."
  sensitive   = true

  validation {
    condition     = length(var.s3_secret_key) > 0
    error_message = "s3_secret_key cannot be empty."
  }
}

variable "s3_endpoint" {
  type        = string
  description = "Endpoint URL of the S3-compatible object storage."

  validation {
    condition     = length(var.s3_endpoint) > 0
    error_message = "s3_endpoint cannot be empty."
  }
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the S3 bucket to use for JuiceFS storage."

  validation {
    condition     = length(var.s3_bucket_name) > 0
    error_message = "s3_bucket_name cannot be empty."
  }
}