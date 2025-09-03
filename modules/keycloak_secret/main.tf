resource "random_password" "keycloak_password" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "keycloak_secret" {
  metadata {
    name      = var.secret_name
    namespace = var.namespace
  }

  data = {
    "${var.secret_key}" = random_password.keycloak_password.result
  }
}