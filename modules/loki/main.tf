resource "kubernetes_namespace" "loki" {
  metadata {
    name = var.namespace
  }
}

# Generate random passwords for each Loki client
resource "random_password" "loki_client_password" {
  for_each = toset(var.loki_clients)

  length  = 32
  special = false
}

# Generate htpasswd entries using bcrypt
locals {
  htpasswd_entries = [
    for client in var.loki_clients :
    "${client}:${bcrypt(random_password.loki_client_password[client].result)}"
  ]
  htpasswd_content = join("\n", local.htpasswd_entries)
}

# Create Kubernetes secret for Loki Gateway htpasswd
resource "kubernetes_secret" "loki_gateway_htpasswd" {
  metadata {
    name      = "loki-gateway-htpasswd"
    namespace = var.namespace
  }

  data = {
    ".htpasswd" = local.htpasswd_content
  }
}

# Create Kubernetes secret for S3 credentials
resource "kubernetes_secret" "loki_s3_credentials" {
  metadata {
    name      = "loki-s3-credentials"
    namespace = var.namespace
  }

  data = {
    accessKeyId     = var.s3_access_key_id
    secretAccessKey = var.s3_secret_access_key
  }

  type = "Opaque"
}
