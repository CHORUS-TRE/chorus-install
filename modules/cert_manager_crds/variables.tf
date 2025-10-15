variable "cert_manager_crds_content" {
  type        = string
  description = "YAML content of the Cert-Manager CRDs to be applied. Should contain one or more Kubernetes manifests in YAML format."
  /*
  This validation is commented out because it throwns error
  when feeding in the cert-manager crds file
  validation {
    condition     = can(yamldecode(var.cert_manager_crds_content))
    error_message = "cert_manager_crds_content must be valid YAML."
  }
*/
}
