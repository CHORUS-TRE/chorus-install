# Create the Velero namespace
resource "kubernetes_namespace" "velero" {
  metadata {
    name = var.namespace
  }
}

# Create Kubernetes secret for Velero S3 credentials
resource "kubernetes_secret" "velero_secret" {

  metadata {
    name      = var.credentials_secret_name
    namespace = var.namespace
  }

  data = {
    "cloud" = <<-EOT
      [default]
      aws_access_key_id=${var.access_key_id}
      aws_secret_access_key=${var.secret_access_key}
    EOT
  }

  type = "Opaque"

  depends_on = [kubernetes_namespace.velero]
}