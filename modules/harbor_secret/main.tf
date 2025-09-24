
# Secrets

resource "random_password" "harbor_secret" {
  # Must be a string of 16 chars.
  length  = 16
  special = false
}

resource "random_password" "harbor_secret_secret_key" {
  # Must be a string of 16 chars.
  length  = 16
  special = false
}

resource "random_password" "harbor_csrf_key" {
  length  = 32
  special = false
}

resource "random_password" "harbor_admin_password" {
  length  = 32
  special = false
}

resource "random_password" "harbor_jobservice_secret" {
  # Must be a string of 16 chars.
  length  = 16
  special = false
}

resource "random_password" "harbor_registry_http_secret" {
  # Must be a string of 16 chars.
  length  = 16
  special = false
}

resource "random_password" "harbor_registry_passwd" {
  length  = 32
  special = false
}

resource "random_password" "salt" {
  length  = 8
  special = false
}

resource "kubernetes_secret" "harbor_core_secret" {
  metadata {
    name      = var.core_secret_name
    namespace = var.namespace
  }

  # Harbor Helm chart does not allow to change the secret key
  # which is why "secret" is hardoced here
  data = {
    "secret" = random_password.harbor_secret.result
  }
}

resource "kubernetes_secret" "harbor_encryption_secret" {
  metadata {
    name      = var.encryption_key_secret_name
    namespace = var.namespace
  }

  # Harbor Helm chart does not allow to change the secret key
  # which is why "secretKey" is hardoced here
  data = {
    "secretKey" = random_password.harbor_secret_secret_key.result
  }
}

resource "kubernetes_secret" "harbor_xsrf_secret" {
  metadata {
    name      = var.xsrf_secret_name
    namespace = var.namespace
  }

  data = {
    "${var.xsrf_secret_key}" = random_password.harbor_csrf_key.result
  }
}

resource "kubernetes_secret" "harbor_admin_password_secret" {
  metadata {
    name      = var.admin_secret_name
    namespace = var.namespace
  }

  data = {
    "${var.admin_secret_key}" = random_password.harbor_admin_password.result
  }
}

resource "kubernetes_secret" "harbor_jobservice_secret" {
  metadata {
    name      = var.jobservice_secret_name
    namespace = var.namespace
  }

  data = {
    "${var.jobservice_secret_key}" = random_password.harbor_jobservice_secret.result
  }
}

resource "kubernetes_secret" "harbor_registry_http_secret" {
  metadata {
    name      = var.registry_secret_name
    namespace = var.namespace
  }

  data = {
    "${var.registry_secret_key}" = random_password.harbor_registry_http_secret.result
  }
}

resource "htpasswd_password" "harbor_registry" {
  password = random_password.harbor_registry_passwd.result
  salt     = random_password.salt.result
}

resource "kubernetes_secret" "harbor_registry_credentials_secret" {
  metadata {
    name      = var.registry_credentials_secret_name
    namespace = var.namespace
  }

  # Harbor Helm chart does not allow to change the secret key
  # which is why "REGISTRY_PASSWD" and
  # "REGISTRY_HTPASSWD" are hardoced here
  data = {
    "REGISTRY_PASSWD"   = random_password.harbor_registry_passwd.result
    "REGISTRY_HTPASSWD" = "${var.harbor_admin_username}:${htpasswd_password.harbor_registry.bcrypt}"
  }
}

resource "kubernetes_secret" "oidc_secret" {
  metadata {
    name      = var.oidc_secret_name
    namespace = var.namespace
  }

  data = {
    "${var.oidc_secret_key}" = var.oidc_config
  }
}