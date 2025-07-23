locals {
  argoci_values_parsed         = yamldecode(var.argoci_helm_values)
  argoci_sensor_regcred_secret = yamldecode(local.argoci_values_parsed.sensor.dockerConfig.secretName)
}

resource "random_password" "argoci_github_workbench_operator_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "argoci_github_workbench_operator" {
  metadata {
    name      = "argo-ci-github-workbench-operator"
    namespace = var.argoci_namespace
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
    namespace = var.argoci_namespace
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
    name      = "argo-ci-github-images"
    namespace = var.argoci_namespace
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
    name      = "argo-ci-github-chorus-backend"
    namespace = var.argoci_namespace
  }

  data = {
    secret = random_password.argoci_github_chorus_backend_secret.result
    token  = var.argoci_github_chorus_backend_token
  }
}

resource "kubernetes_secret" "argoci_github_chorus_backend" {
  metadata {
    name      = local.argoci_sensor_regcred_secret
    namespace = var.argoci_namespace
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      "auths" : {
        "${var.registry_server}" = {
          "auth" : base64encode("${var.registry_username}:${var.registry_password}")
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

# TODO:
# chorus-backend: argo-workflows-github-chorus-backend
#  chorus-web-ui: argo-workflows-github-chorus-web-ui
#  workbench-operator: argo-workflows-github-workbench-operator
# https://github.com/CHORUS-TRE/chorus-tre/blob/903120f86952cd18d8bd183b6a96a9f79f82033b/charts/argo-ci/values.yaml#L43C1-L46C63

# secret has the two following fields
# username
# password
