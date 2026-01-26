resource "kubernetes_namespace" "grafana" {
  metadata {
    name = var.namespace
  }
}

resource "random_password" "grafana_admin_password" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "grafana_oauth_client_secret" {
  metadata {
    name      = var.grafana_oauth_client_secret_name
    namespace = var.namespace
  }

  data = {
    "admin-password"                         = random_password.grafana_admin_password.result
    "admin-user"                             = var.grafana_admin_username
    "${var.grafana_oauth_client_secret_key}" = var.grafana_keycloak_client_secret
  }

  depends_on = [kubernetes_namespace.grafana]
}
