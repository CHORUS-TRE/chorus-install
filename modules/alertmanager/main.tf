resource "kubernetes_secret" "webex" {

  metadata {
    name      = var.webex_secret_name
    namespace = var.alertmanager_namespace
  }

  data = {
    "${var.webex_secret_key}" = var.webex_access_token
  }

  count = var.webex_access_token == "" ? 0 : 1
}