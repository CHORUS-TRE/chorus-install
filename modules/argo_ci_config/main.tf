resource "random_password" "argoci_github_workbench_operator_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "argoci_github_workbench_operator" {
  metadata {
    name      = "argo-ci-github-workbench-operator"
    namespace = var.argocd_namespace
  }

  data = {
    secret = random_password.argoci_github_workbench_operator_secret.result
    token  = var.argoci_github_workbench_operator_token
  }
}

resource "random_password" "argoci_github_chorus_web_ui_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "argoci_github_chorus_web_ui" {
  metadata {
    name      = "argo-ci-github-chorus-web-ui"
    namespace = var.argocd_namespace
  }

  data = {
    secret = random_password.argoci_github_chorus_web_ui_secret.result
    token  = var.argoci_github_chorus_web_ui_token
  }
}

resource "random_password" "argoci_github_images_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "argoci_github_images" {
  metadata {
    name      = "argo-ci-github-images-secret"
    namespace = var.argocd_namespace
  }

  data = {
    secret = random_password.argoci_github_images_secret.result
    token  = var.argoci_github_images_token
  }
}

resource "random_password" "argoci_github_chorus_backend_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "argoci_github_chorus_backend" {
  metadata {
    name      = "argo-ci-github-images-secret"
    namespace = var.argocd_namespace
  }

  data = {
    secret = random_password.argoci_github_chorus_backend_secret.result
    token  = var.argoci_github_chorus_backend_token
  }
}
