# Workbench operator

resource "random_password" "chorusci_github_workbench_operator_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "chorusci_github_workbench_operator" {
  metadata {
    name      = var.webhook_events_map["workbench-operator"].secretName
    namespace = var.chorusci_namespace
  }

  data = {
    (var.webhook_events_map["workbench-operator"].secretKey) = random_password.chorusci_github_workbench_operator_secret.result
  }

  lifecycle {
    precondition {
      condition     = contains(keys(var.webhook_events_map), "workbench-operator")
      error_message = "Not found: 'workbench-operator' webhook event missing in chorus-ci Helm values"
    }
  }
}

# CHORUS Web UI

resource "random_password" "chorusci_github_chorus_web_ui_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "chorusci_github_chorus_web_ui" {
  metadata {
    name      = var.webhook_events_map["chorus-web-ui"].secretName
    namespace = var.chorusci_namespace
  }

  data = {
    (var.webhook_events_map["chorus-web-ui"].secretKey) = random_password.chorusci_github_chorus_web_ui_secret.result
  }

  lifecycle {
    precondition {
      condition     = contains(keys(var.webhook_events_map), "chorus-web-ui")
      error_message = "Not found: 'chorus-web-ui' webhook event missing in chorus-ci Helm values"
    }
  }
}

# Images

resource "random_password" "chorusci_github_images_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "chorusci_github_images" {
  metadata {
    name      = var.webhook_events_map["ci"].secretName
    namespace = var.chorusci_namespace
  }

  data = {
    (var.webhook_events_map["ci"].secretKey) = random_password.chorusci_github_images_secret.result
  }

  lifecycle {
    precondition {
      condition     = contains(keys(var.webhook_events_map), "ci")
      error_message = "Not found: 'ci' webhook event missing in chorus-ci Helm values"
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
    name      = var.webhook_events_map["chorus-backend"].secretName
    namespace = var.chorusci_namespace
  }

  data = {
    (var.webhook_events_map["chorus-backend"].secretKey) = random_password.chorusci_github_chorus_backend_secret.result
  }

  lifecycle {
    precondition {
      condition     = contains(keys(var.webhook_events_map), "chorus-backend")
      error_message = "Not found: 'chorus-backend' webhook event missing in chorus-ci Helm values"
    }
  }
}

# Argo Workflows GitHub Credentials

resource "kubernetes_secret" "argo_workflows_github_pat" {
  metadata {
    name      = var.github_pat_secret_name
    namespace = var.chorusci_namespace
  }

  data = {
    username = "x-access-token"
    password = var.github_pat
  }
}

resource "kubernetes_secret" "argo_workflows_github_app" {
  metadata {
    name      = var.github_app_secret_name
    namespace = var.chorusci_namespace
  }

  data = {
    privateKey = var.github_app_private_key
  }
}

# Sensor

resource "kubernetes_secret" "chorusci_sensor_regcred_secret" {
  metadata {
    name      = var.sensor_regcred_secret_name
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
