resource "random_password" "juicefs_cache_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "juicefs_cache" {
  metadata {
    name      = var.juicefs_cache_secret_name
    namespace = var.juicefs_cache_namespace
  }

  data = {
    "${var.juicefs_cache_secret_key}" = random_password.juicefs_cache_secret.result
  }
}

resource "random_password" "juicefs_dashboard_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "juicefs_dashboard" {
  metadata {
    name      = var.juicefs_dashboard_secret_name
    namespace = var.juicefs_csi_driver_namespace
  }

  data = {
    password = random_password.juicefs_dashboard_secret.result
    username = var.juicefs_dashboard_username
  }
}

# The following secret name is hardcoded because
# the chorus wrapper helm chart for juicefs-csi-driver
# also hardcodes that secret name in the corresponding
# template (i.e. juicefs-sc.yaml)

resource "kubernetes_secret" "juicefs" {
  metadata {
    name      = "juicefs-secret"
    namespace = var.juicefs_csi_driver_namespace
  }

  data = {
    name       = "chorus-data"
    access-key = var.s3_access_key
    secret-key = var.s3_secret_key
    metaurl    = "redis://:${urlencode(random_password.juicefs_cache_secret.result)}@${var.cluster_name}-juicefs-cache-valkey-primary.${var.juicefs_cache_namespace}.svc.cluster.local:6379/1"
    storage    = "s3"
    bucket     = join("/", [var.s3_endpoint, var.s3_bucket_name])
  }
}
