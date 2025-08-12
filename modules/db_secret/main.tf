resource "random_password" "db_password" {
  length  = 32
  special = false
}

resource "random_password" "db_admin_password" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "db_secret" {
  metadata {
    name      = var.secret_name
    namespace = var.namespace
  }

  data = {
    "${var.db_admin_password_key}" = random_password.db_admin_password.result
    "${var.db_user_password_key}"  = random_password.db_password.result
  }
}