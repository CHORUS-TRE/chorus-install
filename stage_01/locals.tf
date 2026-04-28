locals {
  alertmanager_namespace                       = local.prometheus_namespace
  alertmanager_oauth2_proxy_namespace          = jsondecode(file(local.config_files.alertmanager_oauth2_proxy)).namespace
  alertmanager_oauth2_proxy_values_parsed      = yamldecode(file(local.values_files.alertmanager_oauth2_proxy))
  alertmanager_oidc_secret_name                = local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.config.existingSecret
  alertmanager_session_storage_secret_key      = local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.passwordKey
  alertmanager_session_storage_secret_name     = local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.existingSecret
  alertmanager_webex_secret_key                = try(local.kube_prometheus_stack_values_parsed.alertmanagerConfiguration.webex.credentials.key, "")
  alertmanager_webex_secret_name               = try(local.kube_prometheus_stack_values_parsed.alertmanagerConfiguration.webex.credentials.name, "")
  argo_deploy_chart_version                    = jsondecode(file(local.config_files.argo_deploy)).version
  argo_workflows_namespace                     = jsondecode(file(local.config_files.argo_workflows)).namespace
  argo_workflows_sso_server_client_id_key      = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientId.key
  argo_workflows_sso_server_client_id_name     = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientId.name
  argo_workflows_sso_server_client_secret_key  = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientSecret.key
  argo_workflows_sso_server_client_secret_name = local.argo_workflows_values_parsed.argo-workflows.server.sso.clientSecret.name
  argo_workflows_values_parsed                 = yamldecode(file(local.values_files.argo_workflows))
  argo_workflows_workflows_namespaces          = try(toset(local.argo_workflows_values_parsed.argo-workflows.controller.workflowNamespaces), {})
  argocd_cache_chart_version                   = jsondecode(file(local.config_files.argocd_cache)).version
  argocd_chart_version                         = jsondecode(file(local.config_files.argocd)).version
  argocd_keycloak_client_id_key                = regex("\\$[^:]+:(.+)", local.argocd_oidc_config.clientId)[0]
  argocd_keycloak_client_secret_key            = regex("\\$[^:]+:(.+)", local.argocd_oidc_config.clientSecret)[0]
  # Extract key and secret name from  format: $secret-name:key-name
  # We assume all three (issuer, clientId, clientSecret) use the same secret
  argocd_keycloak_issuer_key          = regex("\\$[^:]+:(.+)", local.argocd_oidc_config.issuer)[0]
  argocd_namespace                    = jsondecode(file(local.config_files.argocd)).namespace
  argocd_oidc_config                  = yamldecode(local.argocd_values_parsed.argo-cd.configs.cm["oidc.config"])
  argocd_oidc_secret_name             = regex("\\$([^:]+):", local.argocd_oidc_config.clientSecret)[0]
  argocd_values_parsed                = yamldecode(file(local.values_files.argocd))
  cert_manager_chart_version          = jsondecode(file(local.config_files.cert_manager)).version
  cert_manager_crds_path              = join("/", [var.cert_manager_crds_folder_name, var.cluster_name, var.cert_manager_crds_file_name])
  cert_manager_namespace              = jsondecode(file(local.config_files.cert_manager)).namespace
  chorus_priority_class_chart_version = jsondecode(file(local.config_files.chorus_priority_class)).version
  chorusci_namespace                  = jsondecode(file(local.config_files.chorusci)).namespace
  chorusci_sensor_regcred_secret_name = try(local.chorusci_values_parsed.sensor.dockerConfig.secretName, "regcred")
  chorusci_values_parsed              = yamldecode(file(local.values_files.chorusci))
  chorusci_webhook_events_map = {
    for event in local.chorusci_values_parsed.webhookEvents :
    event.name => { secretName = event.webhookSecretName, secretKey = event.webhookSecretKey }
  }
  config_files = {
    alertmanager_oauth2_proxy = "${var.helm_values_path}/${var.cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/config.json"
    argo_deploy               = "${var.helm_values_path}/${var.cluster_name}/${var.argo_deploy_chart_name}/config.json"
    argo_workflows            = "${var.helm_values_path}/${var.cluster_name}/${var.argo_workflows_chart_name}/config.json"
    argocd                    = "${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/config.json"
    argocd_cache              = "${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}-cache/config.json"
    cert_manager              = "${var.helm_values_path}/${var.cluster_name}/${var.cert_manager_chart_name}/config.json"
    chorus_priority_class     = "${var.helm_values_path}/${var.cluster_name}/${var.chorus_priority_class_chart_name}/config.json"
    chorusci                  = "${var.helm_values_path}/${var.cluster_name}/${var.chorusci_chart_name}/config.json"
    fluent_operator           = "${var.helm_values_path}/${var.cluster_name}/${var.fluent_operator_chart_name}/config.json"
    harbor                    = "${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}/config.json"
    harbor_cache              = "${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}-cache/config.json"
    harbor_db                 = "${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}-db/config.json"
    envoy_gateway             = "${var.helm_values_path}/${var.cluster_name}/${var.envoy_gateway_chart_name}/config.json"
    envoy_gateway_crds        = "${var.helm_values_path}/${var.cluster_name}/${var.envoy_gateway_crds_chart_name}/config.json"
    keycloak                  = "${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}/config.json"
    keycloak_db               = "${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}-db/config.json"
    kube_prometheus_stack     = "${var.helm_values_path}/${var.cluster_name}/${var.kube_prometheus_stack_chart_name}/config.json"
    loki                      = "${var.helm_values_path}/${var.cluster_name}/${var.loki_chart_name}/config.json"
    oauth2_proxy_cache        = "${var.helm_values_path}/${var.cluster_name}/${var.oauth2_proxy_cache_chart_name}/config.json"
    prometheus_oauth2_proxy   = "${var.helm_values_path}/${var.cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/config.json"
    selfsigned                = "${var.helm_values_path}/${var.cluster_name}/${var.selfsigned_chart_name}/config.json"
    velero                    = "${var.helm_values_path}/${var.cluster_name}/${var.velero_chart_name}/config.json"
  }
  fluent_operator_namespace         = jsondecode(file(local.config_files.fluent_operator)).namespace
  grafana_namespace                 = local.prometheus_namespace
  grafana_oauth_client_secret_key   = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana.envValueFrom.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET.secretKeyRef.key
  grafana_oauth_client_secret_name  = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana.envValueFrom.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET.secretKeyRef.name
  harbor_admin_secret_key           = local.harbor_values_parsed.harbor.existingSecretAdminPasswordKey
  harbor_admin_secret_name          = local.harbor_values_parsed.harbor.existingSecretAdminPassword
  harbor_cache_chart_version        = jsondecode(file(local.config_files.harbor_cache)).version
  harbor_chart_version              = jsondecode(file(local.config_files.harbor)).version
  harbor_core_secret_name           = local.harbor_values_parsed.harbor.core.existingSecret
  harbor_db_admin_secret_key        = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  harbor_db_chart_version           = jsondecode(file(local.config_files.harbor_db)).version
  harbor_db_secret_name             = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  harbor_db_user_secret_key         = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
  harbor_db_values_parsed           = yamldecode(file(local.values_files.harbor_db))
  harbor_encryption_key_secret_name = local.harbor_values_parsed.harbor.existingSecretSecretKey
  harbor_jobservice_secret_key      = local.harbor_values_parsed.harbor.jobservice.existingSecretKey
  harbor_jobservice_secret_name     = local.harbor_values_parsed.harbor.jobservice.existingSecret
  harbor_namespace                  = jsondecode(file(local.config_files.harbor)).namespace
  harbor_oidc_config = jsondecode(templatefile("${var.templates_path}/harbor_oidc.tmpl",
    {
      oidc_endpoint      = local.harbor_oidc_endpoint
      oidc_client_id     = var.harbor_keycloak_client_id
      oidc_client_secret = module.keycloak.harbor_keycloak_client_secret
      oidc_admin_group   = var.harbor_keycloak_oidc_admin_group
    }
  ))
  harbor_oidc_config_env = [
    for env in local.harbor_values_parsed.harbor.core.extraEnvVars :
    env if env.name == "CONFIG_OVERWRITE_JSON"
  ][0]
  harbor_oidc_endpoint                    = join("/", [local.keycloak_url, "realms", var.keycloak_realm])
  harbor_oidc_secret_key                  = local.harbor_oidc_config_env.valueFrom.secretKeyRef.key
  harbor_oidc_secret_name                 = local.harbor_oidc_config_env.valueFrom.secretKeyRef.name
  harbor_registry_credentials_secret_name = local.harbor_values_parsed.harbor.registry.credentials.existingSecret
  harbor_registry_http_secret_key         = local.harbor_values_parsed.harbor.registry.existingSecretKey
  harbor_registry_http_secret_name        = local.harbor_values_parsed.harbor.registry.existingSecret
  harbor_robots                           = toset([for robot in local.harbor_values_parsed.robots : robot.name])
  harbor_url                              = local.harbor_values_parsed.harbor.externalURL
  harbor_values_parsed                    = yamldecode(file(local.values_files.harbor))
  harbor_xsrf_secret_key                  = local.harbor_values_parsed.harbor.core.existingXsrfSecretKey
  harbor_xsrf_secret_name                 = local.harbor_values_parsed.harbor.core.existingXsrfSecret
  envoy_gateway_chart_version             = jsondecode(file(local.config_files.envoy_gateway)).version
  envoy_gateway_crds_chart_version        = jsondecode(file(local.config_files.envoy_gateway_crds)).version
  envoy_gateway_namespace                 = jsondecode(file(local.config_files.envoy_gateway)).namespace
  keycloak_chart_version                  = jsondecode(file(local.config_files.keycloak)).version
  keycloak_client_credentials_secret_name = coalesce(
    local.keycloak_values_parsed.client.existingSecret,
    "keycloak-client-credentials"
  )
  keycloak_db_admin_secret_key = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  keycloak_db_chart_version    = jsondecode(file(local.config_files.keycloak_db)).version
  keycloak_db_secret_name      = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  keycloak_db_user_secret_key  = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
  keycloak_db_values_parsed    = yamldecode(file(local.values_files.keycloak_db))
  keycloak_namespace           = jsondecode(file(local.config_files.keycloak)).namespace
  keycloak_remotestate_encryption_key_secret_name = try(
    local.keycloak_values_parsed.keycloak.keycloakConfigCli.extraEnvVars[
      index(local.keycloak_values_parsed.keycloak.keycloakConfigCli.extraEnvVars.*.name, "IMPORT_REMOTESTATE_ENCRYPTIONKEY")
    ].valueFrom.secretKeyRef.name,
    "keycloak-remotestate-encryption-key"
  )
  keycloak_secret_key                            = local.keycloak_values_parsed.keycloak.auth.passwordSecretKey
  keycloak_secret_name                           = local.keycloak_values_parsed.keycloak.auth.existingSecret
  keycloak_url                                   = "https://${local.keycloak_values_parsed.keycloak.ingress.hostname}"
  keycloak_values_parsed                         = yamldecode(file(local.values_files.keycloak))
  kube_prometheus_stack_values_parsed            = yamldecode(file(local.values_files.kube_prometheus_stack))
  oauth2_proxy_cache_namespace                   = jsondecode(file(local.config_files.oauth2_proxy_cache)).namespace
  loki_namespace                                 = jsondecode(file(local.config_files.loki)).namespace
  oauth2_proxy_cache_session_storage_secret_key  = local.oauth2_proxy_cache_values_parsed.valkey.auth.existingSecretPasswordKey
  oauth2_proxy_cache_session_storage_secret_name = local.oauth2_proxy_cache_values_parsed.valkey.auth.existingSecret
  oauth2_proxy_cache_values_parsed               = yamldecode(file(local.values_files.oauth2_proxy_cache))
  prometheus_namespace                           = jsondecode(file(local.config_files.kube_prometheus_stack)).namespace
  prometheus_oauth2_proxy_namespace              = jsondecode(file(local.config_files.prometheus_oauth2_proxy)).namespace
  prometheus_oauth2_proxy_values_parsed          = yamldecode(file(local.values_files.prometheus_oauth2_proxy))
  prometheus_oidc_secret_name                    = local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.config.existingSecret
  prometheus_session_storage_secret_key          = local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.passwordKey
  prometheus_session_storage_secret_name         = local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.existingSecret
  selfsigned_chart_version                       = jsondecode(file(local.config_files.selfsigned)).version
  values_files = {
    alertmanager_oauth2_proxy = "${var.helm_values_path}/${var.cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/values.yaml"
    argo_deploy               = "${var.helm_values_path}/${var.cluster_name}/${var.argo_deploy_chart_name}/values.yaml"
    argo_workflows            = "${var.helm_values_path}/${var.cluster_name}/${var.argo_workflows_chart_name}/values.yaml"
    argocd                    = "${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/values.yaml"
    argocd_cache              = "${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}-cache/values.yaml"
    cert_manager              = "${var.helm_values_path}/${var.cluster_name}/${var.cert_manager_chart_name}/values.yaml"
    chorusci                  = "${var.helm_values_path}/${var.cluster_name}/${var.chorusci_chart_name}/values.yaml"
    harbor                    = "${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}/values.yaml"
    harbor_cache              = "${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}-cache/values.yaml"
    harbor_db                 = "${var.helm_values_path}/${var.cluster_name}/${var.harbor_chart_name}-db/values.yaml"
    envoy_gateway             = "${var.helm_values_path}/${var.cluster_name}/${var.envoy_gateway_chart_name}/values.yaml"
    envoy_gateway_crds        = "${var.helm_values_path}/${var.cluster_name}/${var.envoy_gateway_crds_chart_name}/values.yaml"
    keycloak                  = "${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}/values.yaml"
    keycloak_db               = "${var.helm_values_path}/${var.cluster_name}/${var.keycloak_chart_name}-db/values.yaml"
    kube_prometheus_stack     = "${var.helm_values_path}/${var.cluster_name}/${var.kube_prometheus_stack_chart_name}/values.yaml"
    oauth2_proxy_cache        = "${var.helm_values_path}/${var.cluster_name}/${var.oauth2_proxy_cache_chart_name}/values.yaml"
    prometheus_oauth2_proxy   = "${var.helm_values_path}/${var.cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/values.yaml"
    selfsigned                = "${var.helm_values_path}/${var.cluster_name}/${var.selfsigned_chart_name}/values.yaml"
    velero                    = "${var.helm_values_path}/${var.cluster_name}/${var.velero_chart_name}/values.yaml"
  }
  velero_namespace               = jsondecode(file(local.config_files.velero)).namespace
  velero_values_parsed           = yamldecode(file(local.values_files.velero))
  velero_credentials_secret_name = local.velero_values_parsed.velero.credentials.existingSecret
}
