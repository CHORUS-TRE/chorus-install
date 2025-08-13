locals {
  chorusci_values_parsed         = yamldecode(var.chorusci_helm_values)
  chorusci_sensor_regcred_secret = yamldecode(local.chorusci_values_parsed.sensor.dockerConfig.secretName)
  webhook_events                 = { for event in local.chorusci_values_parsed.webhookEvents : event.name => event.secretName }
}

# Workbench operator

resource "random_password" "chorusci_github_workbench_operator_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "chorusci_github_workbench_operator" {
  metadata {
    name      = local.webhook_events["workbench-operator"]
    namespace = var.chorusci_namespace
  }

  data = {
    secret = random_password.chorusci_github_workbench_operator_secret.result
    token  = var.github_workbench_operator_token
  }

  lifecycle {
    precondition {
      condition     = anytrue([for k, v in local.webhook_events : k == "workbench-operator"])
      error_message = "Not found: 'workbench-operator' webhook event missing in argo-ci Helm values"
    }
  }
}

resource "kubernetes_secret" "argo_workflows_github_workbench_operator" {
  metadata {
    name      = "argo-workflows-github-workbench-operator"
    namespace = var.chorusci_namespace
  }

  data = {
    username = var.github_username
    password = var.github_workbench_operator_token
  }
}

# CHORUS Web UI

resource "random_password" "chorusci_github_chorus_web_ui_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "chorusci_github_chorus_web_ui" {
  metadata {
    name      = local.webhook_events["chorus-web-ui"]
    namespace = var.chorusci_namespace
  }

  data = {
    secret = random_password.chorusci_github_chorus_web_ui_secret.result
    token  = var.github_chorus_web_ui_token
  }

  lifecycle {
    precondition {
      condition     = anytrue([for k, v in local.webhook_events : k == "chorus-web-ui"])
      error_message = "Not found: 'chorus-web-ui' webhook event missing in argo-ci Helm values"
    }
  }
}

resource "kubernetes_secret" "argo_workflows_github_chorus_web_ui" {
  metadata {
    name      = "argo-workflows-github-chorus-web-ui"
    namespace = var.chorusci_namespace
  }

  data = {
    username = var.github_username
    password = var.github_chorus_web_ui_token
  }
}

# Images

resource "random_password" "chorusci_github_images_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "chorusci_github_images" {
  metadata {
    name      = local.webhook_events["ci"]
    namespace = var.chorusci_namespace
  }

  data = {
    secret = random_password.chorusci_github_images_secret.result
    token  = var.github_images_token
  }

  lifecycle {
    precondition {
      condition     = anytrue([for k, v in local.webhook_events : k == "ci"])
      error_message = "Not found: 'ci' webhook event missing in argo-ci Helm values"
    }
  }
}

# CHORUS Backend

resource "random_password" "chorusci_github_chorus_backend_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "chorusci_github_chorus_backend" {
  metadata {
    name      = local.webhook_events["chorus-backend"]
    namespace = var.chorusci_namespace
  }

  data = {
    secret = random_password.chorusci_github_chorus_backend_secret.result
    token  = var.github_chorus_backend_token
  }

  lifecycle {
    precondition {
      condition     = anytrue([for k, v in local.webhook_events : k == "chorus-backend"])
      error_message = "Not found: 'chorus-backend' webhook event missing in argo-ci Helm values"
    }
  }
}

resource "kubernetes_secret" "argo_workflows_github_chorus_backend" {
  metadata {
    name      = "argo-workflows-github-chorus-backend"
    namespace = var.chorusci_namespace
  }

  data = {
    username = var.github_username
    password = var.github_chorus_backend_token
  }
}

# Sensor

resource "kubernetes_secret" "chorusci_sensor_regcred_secret" {
  metadata {
    name      = local.chorusci_sensor_regcred_secret
    namespace = var.chorusci_namespace
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
