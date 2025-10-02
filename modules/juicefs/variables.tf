variable "cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster where JuiceFS will be deployed."
}

variable "juicefs_cache_secret_name" {
  type        = string
  description = "Name of the Kubernetes Secret used for JuiceFS cache credentials."
}

variable "juicefs_cache_secret_key" {
  type        = string
  description = "Key of the Kubernetes Secret used for JuiceFS cache credentials."
}

variable "juicefs_cache_namespace" {
  type        = string
  description = "Namespace where the JuiceFS cache is located."
}

variable "juicefs_dashboard_secret_name" {
  type        = string
  description = "Name of the Kubernetes Secret containing JuiceFS dashboard credentials."
}

variable "juicefs_csi_driver_namespace" {
  type        = string
  description = "Namespace where the JuiceFS CSI driver is deployed."
}

variable "juicefs_dashboard_username" {
  type        = string
  description = "Username used to authenticate to the JuiceFS dashboard."
}

variable "s3_access_key" {
  type        = string
  description = "Access key for the S3-compatible object storage."
}

variable "s3_secret_key" {
  type        = string
  description = "Secret key for the S3-compatible object storage."
}

variable "s3_endpoint" {
  type        = string
  description = "Endpoint URL of the S3-compatible object storage."
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the S3 bucket to use for JuiceFS storage."
}