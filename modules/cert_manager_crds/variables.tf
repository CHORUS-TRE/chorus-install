variable "cert_manager_crds_content" {
  type        = string
  description = "YAML content of the Cert-Manager CRDs to be applied. Should contain one or more Kubernetes manifests in YAML format."

  validation {
    condition     = length(var.cert_manager_crds_content) > 0
    error_message = "cert_manager_crds_content cannot be empty."
  }

  validation {
    condition     = can(yamldecode(var.cert_manager_crds_content))
    error_message = "cert_manager_crds_content must be valid YAML."
  }
}