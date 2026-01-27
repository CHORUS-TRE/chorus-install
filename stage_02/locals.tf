locals {
  alertmanager_oauth2_proxy_namespace      = jsondecode(file(local.config_files.alertmanager_oauth2_proxy)).namespace
  alertmanager_oauth2_proxy_values         = file(local.values_files.alertmanager_oauth2_proxy)
  alertmanager_oauth2_proxy_values_parsed  = yamldecode(file(local.values_files.alertmanager_oauth2_proxy))
  alertmanager_oidc_secret_name            = local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.config.existingSecret
  alertmanager_session_storage_secret_key  = local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.passwordKey
  alertmanager_session_storage_secret_name = local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.existingSecret
  alertmanager_url                         = "https://${local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"
  alertmanager_webex_secret_key            = try(local.kube_prometheus_stack_values_parsed.alertmanagerConfiguration.webex.credentials.key, "")
  alertmanager_webex_secret_name           = try(local.kube_prometheus_stack_values_parsed.alertmanagerConfiguration.webex.credentials.name, "")
  argocd_namespace                         = jsondecode(file(local.config_files.argocd)).namespace
  backend_db_admin_secret_key              = local.backend_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  backend_db_namespace                     = jsondecode(file(local.config_files.backend_db)).namespace
  backend_db_secret_name                   = local.backend_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  backend_db_user_secret_key               = local.backend_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
  backend_db_values                        = file(local.values_files.backend_db)
  backend_db_values_parsed                 = yamldecode(local.backend_db_values)
  backend_keycloak_dev_enabled = try(
    local.backend_values_parsed.config.services.authentication_service.mode.keycloakdev.enabled,
    false
  )
  backend_namespace = jsondecode(file(local.config_files.backend)).namespace
  backend_secrets_content = templatefile("${var.templates_path}/backend_secrets.tmpl",
    {
      daemon_jwt_secret                      = random_password.jwt_signature.result
      daemon_metrics_authentication_enabled  = "true"
      daemon_metrics_authentication_username = "prometheus"
      daemon_metrics_authentication_password = random_password.metrics_password.result
      daemon_private_key                     = indent(2, trimspace(tls_private_key.chorus_backend_daemon.private_key_pem))
      storage_datastores_chorus_password     = module.backend_db_secret.db_password
      k8s_client_is_watcher                  = "true"
      k8s_client_api_server                  = var.remote_cluster_server
      k8s_client_image_pull_secrets = [
        {
          registry = "${local.harbor_values_parsed.harbor.expose.ingress.hosts.core}"
          username = join("", ["robot$", "${var.remote_cluster_name}"])
          password = module.harbor_secret.harbor_robot_secrets["${var.remote_cluster_name}"]
        }
      ]
      keycloak_openid_client_secret = module.keycloak_secret.chorus_client_secret
      keycloak_dev_enabled          = local.backend_keycloak_dev_enabled
      steward_password              = random_password.steward_password.result
      backend_s3_enabled            = try(local.backend_values_parsed.main.clients.minio_client.enabled, false)
      juicefs_endpoint              = try(local.backend_values_parsed.main.clients.minio_client.endpoint, "")
      s3_access_key                 = var.s3_access_key
      s3_secret_key                 = var.s3_secret_key
      s3_bucket_name                = var.s3_bucket_name
    }
  )
  backend_url               = "https://${local.backend_values_parsed.ingress.hosts.0.host}"
  backend_values            = file(local.values_files.backend)
  backend_values_parsed     = yamldecode(local.backend_values)
  cert_manager_crds_content = file("${var.cert_manager_crds_path}/${var.remote_cluster_name}/cert-manager.crds.yaml")
  config_files = {
    # ArgoCD runs on build cluster
    argocd = "${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/config.json"
    # Remote cluster resources
    keycloak                  = "${var.helm_values_path}/${var.remote_cluster_name}/${var.keycloak_chart_name}/config.json"
    harbor                    = "${var.helm_values_path}/${var.remote_cluster_name}/${var.harbor_chart_name}/config.json"
    kube_prometheus_stack     = "${var.helm_values_path}/${var.remote_cluster_name}/${var.kube_prometheus_stack_chart_name}/config.json"
    prometheus_oauth2_proxy   = "${var.helm_values_path}/${var.remote_cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/config.json"
    alertmanager_oauth2_proxy = "${var.helm_values_path}/${var.remote_cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/config.json"
    oauth2_proxy_cache        = "${var.helm_values_path}/${var.remote_cluster_name}/${var.oauth2_proxy_cache_chart_name}/config.json"
    matomo                    = "${var.helm_values_path}/${var.remote_cluster_name}/${var.matomo_chart_name}/config.json"
    matomo_db                 = "${var.helm_values_path}/${var.remote_cluster_name}/${var.matomo_chart_name}-db/config.json"
    backend                   = "${var.helm_values_path}/${var.remote_cluster_name}/${var.backend_chart_name}/config.json"
    backend_db                = "${var.helm_values_path}/${var.remote_cluster_name}/${var.backend_chart_name}-db/config.json"
    i2b2_wildfly              = "${var.helm_values_path}/${var.remote_cluster_name}/${var.i2b2_chart_name}-wildfly/config.json"
    i2b2_db                   = "${var.helm_values_path}/${var.remote_cluster_name}/${var.i2b2_chart_name}-db/config.json"
    didata                    = "${var.helm_values_path}/${var.remote_cluster_name}/${var.didata_chart_name}/config.json"
    didata_db                 = "${var.helm_values_path}/${var.remote_cluster_name}/${var.didata_chart_name}-db/config.json"
    juicefs_csi_driver        = "${var.helm_values_path}/${var.remote_cluster_name}/${var.juicefs_chart_name}-csi-driver/config.json"
    juicefs_s3_gateway        = "${var.helm_values_path}/${var.remote_cluster_name}/${var.juicefs_chart_name}-s3-gateway/config.json"
    juicefs_cache             = "${var.helm_values_path}/${var.remote_cluster_name}/${var.juicefs_chart_name}-cache/config.json"
    reflector                 = "${var.helm_values_path}/${var.remote_cluster_name}/${var.reflector_chart_name}/config.json"
  }
  didata_db_namespace     = jsondecode(file(local.config_files.didata_db)).namespace
  didata_db_secret_name   = local.didata_db_values_parsed.mariadb.auth.existingSecret
  didata_db_values        = file(local.values_files.didata_db)
  didata_db_values_parsed = yamldecode(local.didata_db_values)
  didata_namespace        = jsondecode(file(local.config_files.didata)).namespace
  didata_secrets_content = templatefile("${var.templates_path}/didata_secrets.tmpl",
    {
      didata_app_name    = "didata_chorus"
      didata_app_key     = var.didata_app_key
      didata_app_url     = local.didata_url
      didata_db_host     = "${var.remote_cluster_name}-didata-db-mariadb"
      didata_db_database = "didata"
      didata_db_username = "didata"
      didata_db_password = random_password.didata_db_password.result
      didata_jwt_secret  = random_password.didata_jwt_secret.result
    }
  )
  didata_url                        = "https://didata.${var.remote_cluster_name}.chorus-tre.ch/"
  frontend_url                      = "https://${local.frontend_values_parsed.ingress.hosts.0.host}"
  frontend_values                   = file(local.values_files.frontend)
  frontend_values_parsed            = yamldecode(local.frontend_values)
  grafana_oauth_client_secret_key   = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana.envValueFrom.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET.secretKeyRef.key
  grafana_oauth_client_secret_name  = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana.envValueFrom.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET.secretKeyRef.name
  grafana_url                       = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana["grafana.ini"].server.root_url
  harbor_admin_secret_key           = local.harbor_values_parsed.harbor.existingSecretAdminPasswordKey
  harbor_admin_secret_name          = local.harbor_values_parsed.harbor.existingSecretAdminPassword
  harbor_core_secret_name           = local.harbor_values_parsed.harbor.core.existingSecret
  harbor_db_admin_secret_key        = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  harbor_db_secret_name             = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  harbor_db_user_secret_key         = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
  harbor_db_values                  = file(local.values_files.harbor_db)
  harbor_db_values_parsed           = yamldecode(local.harbor_db_values)
  harbor_encryption_key_secret_name = local.harbor_values_parsed.harbor.existingSecretSecretKey
  harbor_jobservice_secret_key      = local.harbor_values_parsed.harbor.jobservice.existingSecretKey
  harbor_jobservice_secret_name     = local.harbor_values_parsed.harbor.jobservice.existingSecret
  harbor_namespace                  = jsondecode(file(local.config_files.harbor)).namespace
  harbor_oidc_config = jsondecode(templatefile("${var.templates_path}/harbor_oidc.tmpl",
    {
      oidc_endpoint      = local.harbor_oidc_endpoint
      oidc_client_id     = var.harbor_keycloak_client_id
      oidc_client_secret = module.keycloak_secret.harbor_client_secret
      oidc_admin_group   = var.harbor_keycloak_oidc_admin_group
    }
  ))
  harbor_oidc_config_env = [
    for env in local.harbor_values_parsed.harbor.core.extraEnvVars :
    env if env.name == "CONFIG_OVERWRITE_JSON"
  ][0]
  harbor_oidc_endpoint                    = join("/", [local.keycloak_url, "realms", var.keycloak_infra_realm])
  harbor_oidc_secret_key                  = local.harbor_oidc_config_env.valueFrom.secretKeyRef.key
  harbor_oidc_secret_name                 = local.harbor_oidc_config_env.valueFrom.secretKeyRef.name
  harbor_registry_credentials_secret_name = local.harbor_values_parsed.harbor.registry.credentials.existingSecret
  harbor_registry_http_secret_key         = local.harbor_values_parsed.harbor.registry.existingSecretKey
  harbor_registry_http_secret_name        = local.harbor_values_parsed.harbor.registry.existingSecret
  harbor_robots                           = toset([for robot in local.harbor_values_parsed.robots : robot.name])
  harbor_url                              = local.harbor_values_parsed.harbor.externalURL
  harbor_values                           = file(local.values_files.harbor)
  harbor_values_parsed                    = yamldecode(local.harbor_values)
  harbor_xsrf_secret_key                  = local.harbor_values_parsed.harbor.core.existingXsrfSecretKey
  harbor_xsrf_secret_name                 = local.harbor_values_parsed.harbor.core.existingXsrfSecret
  i2b2_db_namespace                       = jsondecode(file(local.config_files.i2b2_db)).namespace
  i2b2_wildfly_namespace                  = jsondecode(file(local.config_files.i2b2_wildfly)).namespace
  juicefs_cache_namespace                 = jsondecode(file(local.config_files.juicefs_cache)).namespace
  juicefs_cache_values                    = file(local.values_files.juicefs_cache)
  juicefs_cache_values_parsed             = yamldecode(local.juicefs_cache_values)
  juicefs_csi_driver_namespace            = jsondecode(file(local.config_files.juicefs_csi_driver)).namespace
  juicefs_csi_driver_values               = file(local.values_files.juicefs_csi_driver)
  juicefs_csi_driver_values_parsed        = yamldecode(local.juicefs_csi_driver_values)
  keycloak_client_credentials_secret_name = coalesce(
    local.keycloak_values_parsed.client.existingSecret,
    "keycloak-client-credentials"
  )
  keycloak_db_admin_secret_key = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  keycloak_db_secret_name      = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  keycloak_db_user_secret_key  = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
  keycloak_db_values           = file(local.values_files.keycloak_db)
  keycloak_db_values_parsed    = yamldecode(local.keycloak_db_values)
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
  keycloak_values                                = file(local.values_files.keycloak)
  keycloak_values_parsed                         = yamldecode(local.keycloak_values)
  kube_prometheus_stack_values                   = file(local.values_files.kube_prometheus_stack)
  kube_prometheus_stack_values_parsed            = yamldecode(local.kube_prometheus_stack_values)
  matomo_db_host                                 = local.matomo_values_parsed.matomo.externalDatabase.host
  matomo_db_namespace                            = jsondecode(file(local.config_files.matomo_db)).namespace
  matomo_db_secret_name                          = local.matomo_db_values_parsed.mariadb.auth.existingSecret
  matomo_db_values                               = file(local.values_files.matomo_db)
  matomo_db_values_parsed                        = yamldecode(local.matomo_db_values)
  matomo_namespace                               = jsondecode(file(local.config_files.matomo)).namespace
  matomo_secret_name                             = local.matomo_values_parsed.matomo.existingSecret
  matomo_url                                     = "https://${local.matomo_values_parsed.matomo.ingress.hostname}"
  matomo_values                                  = file(local.values_files.matomo)
  matomo_values_parsed                           = yamldecode(local.matomo_values)
  oauth2_proxy_cache_namespace                   = jsondecode(file(local.config_files.oauth2_proxy_cache)).namespace
  oauth2_proxy_cache_session_storage_secret_key  = local.oauth2_proxy_cache_values_parsed.valkey.auth.existingSecretPasswordKey
  oauth2_proxy_cache_session_storage_secret_name = local.oauth2_proxy_cache_values_parsed.valkey.auth.existingSecret
  oauth2_proxy_cache_values_parsed               = yamldecode(file(local.values_files.oauth2_proxy_cache))
  prometheus_namespace                           = jsondecode(file(local.config_files.kube_prometheus_stack)).namespace
  prometheus_oauth2_proxy_namespace              = jsondecode(file(local.config_files.prometheus_oauth2_proxy)).namespace
  prometheus_oauth2_proxy_values                 = file(local.values_files.prometheus_oauth2_proxy)
  prometheus_oauth2_proxy_values_parsed          = yamldecode(file(local.values_files.prometheus_oauth2_proxy))
  prometheus_oidc_secret_name                    = local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.config.existingSecret
  prometheus_session_storage_secret_key          = local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.passwordKey
  prometheus_session_storage_secret_name         = local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.sessionStorage.redis.existingSecret
  prometheus_url                                 = "https://${local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"
  reflector_namespace                            = jsondecode(file(local.config_files.reflector)).namespace
  remote_cluster_config = jsonencode({
    bearerToken = data.kubernetes_secret.argocd_manager_token.data.token
    tlsClientConfig = {
      insecure = var.remote_cluster_insecure
      caData   = base64encode(data.kubernetes_config_map.ca_data.data["ca.crt"])
    }
  })
  values_files = {
    keycloak                  = "${var.helm_values_path}/${var.remote_cluster_name}/${var.keycloak_chart_name}/values.yaml"
    keycloak_db               = "${var.helm_values_path}/${var.remote_cluster_name}/${var.keycloak_chart_name}-db/values.yaml"
    harbor                    = "${var.helm_values_path}/${var.remote_cluster_name}/${var.harbor_chart_name}/values.yaml"
    harbor_db                 = "${var.helm_values_path}/${var.remote_cluster_name}/${var.harbor_chart_name}-db/values.yaml"
    kube_prometheus_stack     = "${var.helm_values_path}/${var.remote_cluster_name}/${var.kube_prometheus_stack_chart_name}/values.yaml"
    prometheus_oauth2_proxy   = "${var.helm_values_path}/${var.remote_cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/values.yaml"
    alertmanager_oauth2_proxy = "${var.helm_values_path}/${var.remote_cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/values.yaml"
    oauth2_proxy_cache        = "${var.helm_values_path}/${var.remote_cluster_name}/${var.oauth2_proxy_cache_chart_name}/values.yaml"
    matomo                    = "${var.helm_values_path}/${var.remote_cluster_name}/${var.matomo_chart_name}/values.yaml"
    matomo_db                 = "${var.helm_values_path}/${var.remote_cluster_name}/${var.matomo_chart_name}-db/values.yaml"
    frontend                  = "${var.helm_values_path}/${var.remote_cluster_name}/${var.frontend_chart_name}/values.yaml"
    backend                   = "${var.helm_values_path}/${var.remote_cluster_name}/${var.backend_chart_name}/values.yaml"
    backend_db                = "${var.helm_values_path}/${var.remote_cluster_name}/${var.backend_chart_name}-db/values.yaml"
    didata_db                 = "${var.helm_values_path}/${var.remote_cluster_name}/${var.didata_chart_name}-db/values.yaml"
    juicefs_csi_driver        = "${var.helm_values_path}/${var.remote_cluster_name}/${var.juicefs_chart_name}-csi-driver/values.yaml"
    juicefs_cache             = "${var.helm_values_path}/${var.remote_cluster_name}/${var.juicefs_chart_name}-cache/values.yaml"
  }
}
