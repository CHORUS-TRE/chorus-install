resource "kubernetes_manifest" "cert_manager_crds" {
  for_each = {
    for manifest in provider::kubernetes::manifest_decode_multi(
      var.cert_manager_crds_content
    ) :
    manifest.metadata.name => manifest
  }

  manifest = each.value
}