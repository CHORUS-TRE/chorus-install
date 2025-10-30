locals {
  helm_values_folders = toset([for x in fileset("${path.module}/${var.helm_values_path}/${var.cluster_name}", "**") : dirname(x)])
  charts_versions     = { for x in local.helm_values_folders : jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${x}/config.json")).chart => jsondecode(file("${var.helm_values_path}/${var.cluster_name}/${x}/config.json")).version... }

  config_files = {
    argo_deploy               = "${var.helm_values_path}/${var.cluster_name}/${var.argo_deploy_chart_name}/config.json"
    argocd                    = "${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/config.json"
    argocd_cache              = "${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}-cache/config.json"
    chorusci                  = "${var.helm_values_path}/${var.cluster_name}/${var.chorusci_chart_name}/config.json"
    harbor                    = "${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}/config.json"
    keycloak                  = "${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}/config.json"
    kube_prometheus_stack     = "${var.helm_values_path}/${var.cluster_name}/${var.kube_prometheus_stack_chart_name}/config.json"
    prometheus_oauth2_proxy   = "${var.helm_values_path}/${var.cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/config.json"
    alertmanager_oauth2_proxy = "${var.helm_values_path}/${var.cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/config.json"
    oauth2_proxy_cache        = "${var.helm_values_path}/${var.cluster_name}/${var.oauth2_proxy_cache_chart_name}/config.json"
    argo_workflows            = "${var.helm_values_path}/${var.cluster_name}/${var.argo_workflows_chart_name}/config.json"
  }

  values_files = {
    argo_deploy               = "${var.helm_values_path}/${var.cluster_name}/${var.argo_deploy_chart_name}/values.yaml"
    argocd                    = "${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/values.yaml"
    argocd_cache              = "${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}-cache/values.yaml"
    chorusci                  = "${var.helm_values_path}/${var.cluster_name}/${var.chorusci_chart_name}/values.yaml"
    harbor                    = "${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}/values.yaml"
    harbor_db                 = "${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}-db/values.yaml"
    keycloak                  = "${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}/values.yaml"
    keycloak_db               = "${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}-db/values.yaml"
    kube_prometheus_stack     = "${var.helm_values_path}/${var.cluster_name}/${var.kube_prometheus_stack_chart_name}/values.yaml"
    argo_workflows            = "${var.helm_values_path}/${var.cluster_name}/${var.argo_workflows_chart_name}/values.yaml"
    alertmanager_oauth2_proxy = "${var.helm_values_path}/${var.cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/values.yaml"
    prometheus_oauth2_proxy   = "${var.helm_values_path}/${var.cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/values.yaml"
    oauth2_proxy_cache        = "${var.helm_values_path}/${var.cluster_name}/${var.oauth2_proxy_cache_chart_name}/values.yaml"
  }

  argo_deploy_chart_version  = jsondecode(file(local.config_files.argo_deploy)).version
  argocd_chart_version       = jsondecode(file(local.config_files.argocd)).version
  argocd_cache_chart_version = jsondecode(file(local.config_files.argocd_cache)).version

  argocd_namespace                    = jsondecode(file(local.config_files.argocd)).namespace
  chorusci_namespace                  = jsondecode(file(local.config_files.chorusci)).namespace
  harbor_namespace                    = jsondecode(file(local.config_files.harbor)).namespace
  keycloak_namespace                  = jsondecode(file(local.config_files.keycloak)).namespace
  prometheus_namespace                = jsondecode(file(local.config_files.kube_prometheus_stack)).namespace
  alertmanager_namespace              = local.prometheus_namespace
  grafana_namespace                   = local.prometheus_namespace
  prometheus_oauth2_proxy_namespace   = jsondecode(file(local.config_files.prometheus_oauth2_proxy)).namespace
  alertmanager_oauth2_proxy_namespace = jsondecode(file(local.config_files.alertmanager_oauth2_proxy)).namespace
  argo_workflows_namespace            = jsondecode(file(local.config_files.argo_workflows)).namespace
  oauth2_proxy_cache_namespace        = jsondecode(file(local.config_files.oauth2_proxy_cache)).namespace

  harbor_values                    = file(local.values_files.harbor)
  harbor_db_values                 = file(local.values_files.harbor_db)
  keycloak_values                  = file(local.values_files.keycloak)
  keycloak_db_values               = file(local.values_files.keycloak_db)
  kube_prometheus_stack_values     = file(local.values_files.kube_prometheus_stack)
  prometheus_oauth2_proxy_values   = file(local.values_files.prometheus_oauth2_proxy)
  alertmanager_oauth2_proxy_values = file(local.values_files.alertmanager_oauth2_proxy)
  oauth2_proxy_cache_values        = file(local.values_files.oauth2_proxy_cache)
  argo_workflows_values            = file(local.values_files.argo_workflows)

  harbor_values_parsed                    = yamldecode(local.harbor_values)
  harbor_db_values_parsed                 = yamldecode(local.harbor_db_values)
  keycloak_values_parsed                  = yamldecode(local.keycloak_values)
  keycloak_db_values_parsed               = yamldecode(local.keycloak_db_values)
  kube_prometheus_stack_values_parsed     = yamldecode(local.kube_prometheus_stack_values)
  prometheus_oauth2_proxy_values_parsed   = yamldecode(local.prometheus_oauth2_proxy_values)
  alertmanager_oauth2_proxy_values_parsed = yamldecode(local.alertmanager_oauth2_proxy_values)
  argo_workflows_values_parsed            = yamldecode(local.argo_workflows_values)

  harbor_url                       = local.harbor_values_parsed.harbor.externalURL
  harbor_admin_password_secret     = local.harbor_values_parsed.harbor.existingSecretAdminPassword
  harbor_admin_password_secret_key = local.harbor_values_parsed.harbor.existingSecretAdminPasswordKey
  harbor_admin_password            = data.kubernetes_secret.harbor_admin_password.data["${local.harbor_admin_password_secret_key}"]
  harbor_oidc_secret               = local.harbor_values_parsed.harbor.core.extraEnvVars.0.valueFrom.secretKeyRef.name
  harbor_oidc_secret_key           = local.harbor_values_parsed.harbor.core.extraEnvVars.0.valueFrom.secretKeyRef.key
  harbor_keycloak_client_secret    = jsondecode(data.kubernetes_secret.harbor_oidc.data["${local.harbor_oidc_secret_key}"]).oidc_client_secret

  harbor_db_secret             = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  harbor_db_user_password_key  = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
  harbor_db_admin_password_key = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey

  keycloak_url                       = "https://${local.keycloak_values_parsed.keycloak.ingress.hostname}"
  keycloak_admin_password_secret     = local.keycloak_values_parsed.keycloak.auth.existingSecret
  keycloak_admin_password_secret_key = local.keycloak_values_parsed.keycloak.auth.passwordSecretKey
  keycloak_admin_password            = data.kubernetes_secret.keycloak_admin_password.data["${local.keycloak_admin_password_secret_key}"]

  keycloak_db_secret             = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  keycloak_db_user_password_key  = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
  keycloak_db_admin_password_key = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey

  grafana_url                     = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana["grafana.ini"].server.root_url
  grafana_oauth_client_secret     = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana.envValueFrom.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET.secretKeyRef.name
  grafana_oauth_client_secret_key = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana.envValueFrom.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET.secretKeyRef.key

  prometheus_url                 = "https://${local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"
  alertmanager_url               = "https://${local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"
  alertmanager_webex_secret_name = try(local.kube_prometheus_stack_values_parsed.alertmanagerConfiguration.webex.credentials.name, "")
  alertmanager_webex_secret_key  = try(local.kube_prometheus_stack_values_parsed.alertmanagerConfiguration.webex.credentials.key, "")

  argo_workflows_url                           = "https://${local.argo_workflows_values_parsed.argo-workflows.server.ingress.hosts.0}"
  argo_workflows_redirect_uri                  = local.argo_workflows_values_parsed.argo-workflows.server.sso.redirectUrl
  argo_workflows_sso_server_client_id_name     = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientId.name
  argo_workflows_sso_server_client_id_key      = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientId.key
  argo_workflows_sso_server_client_secret_name = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientSecret.name
  argo_workflows_sso_server_client_secret_key  = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientSecret.key
  argo_workflows_workflow_namespace            = local.argo_workflows_values_parsed.argo-workflows.controller.workflowNamespaces.0
}