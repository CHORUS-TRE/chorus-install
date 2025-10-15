locals {
  remote_cluster_name = coalesce(var.remote_cluster_name, var.remote_cluster_kubeconfig_context)
  build_cluster_name  = coalesce(var.cluster_name, var.kubeconfig_context)

  config_files = {
    # Build cluster files
    build_cluster_harbor = "${var.helm_values_path}/${local.build_cluster_name}/${var.harbor_chart_name}/config.json"
    # Remote cluster files
    keycloak                  = "${var.helm_values_path}/${local.remote_cluster_name}/${var.keycloak_chart_name}/config.json"
    harbor                    = "${var.helm_values_path}/${local.remote_cluster_name}/${var.harbor_chart_name}/config.json"
    kube_prometheus_stack     = "${var.helm_values_path}/${local.remote_cluster_name}/${var.kube_prometheus_stack_chart_name}/config.json"
    prometheus_oauth2_proxy   = "${var.helm_values_path}/${local.remote_cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/config.json"
    alertmanager_oauth2_proxy = "${var.helm_values_path}/${local.remote_cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/config.json"
    oauth2_proxy_cache        = "${var.helm_values_path}/${local.remote_cluster_name}/${var.oauth2_proxy_cache_chart_name}/config.json"
    matomo                    = "${var.helm_values_path}/${local.remote_cluster_name}/${var.matomo_chart_name}/config.json"
    matomo_db                 = "${var.helm_values_path}/${local.remote_cluster_name}/${var.matomo_chart_name}-db/config.json"
    backend                   = "${var.helm_values_path}/${local.remote_cluster_name}/${var.backend_chart_name}/config.json"
    backend_db                = "${var.helm_values_path}/${local.remote_cluster_name}/${var.backend_chart_name}-db/config.json"
    i2b2_wildfly              = "${var.helm_values_path}/${local.remote_cluster_name}/${var.i2b2_chart_name}-wildfly/config.json"
    i2b2_db                   = "${var.helm_values_path}/${local.remote_cluster_name}/${var.i2b2_chart_name}-db/config.json"
    didata                    = "${var.helm_values_path}/${local.remote_cluster_name}/${var.didata_chart_name}/config.json"
    didata_db                 = "${var.helm_values_path}/${local.remote_cluster_name}/${var.didata_chart_name}-db/config.json"
    juicefs_csi_driver        = "${var.helm_values_path}/${local.remote_cluster_name}/${var.juicefs_chart_name}-csi-driver/config.json"
    juicefs_s3_gateway        = "${var.helm_values_path}/${local.remote_cluster_name}/${var.juicefs_chart_name}-s3-gateway/config.json"
    juicefs_cache             = "${var.helm_values_path}/${local.remote_cluster_name}/${var.juicefs_chart_name}-cache/config.json"
  }

  values_files = {
    # Build cluster files
    build_cluster_harbor = "${var.helm_values_path}/${local.build_cluster_name}/${var.harbor_chart_name}/values.yaml"
    # Remote cluster files
    keycloak                  = "${var.helm_values_path}/${local.remote_cluster_name}/${var.keycloak_chart_name}/values.yaml"
    keycloak_db               = "${var.helm_values_path}/${local.remote_cluster_name}/${var.keycloak_chart_name}-db/values.yaml"
    harbor_values             = "${var.helm_values_path}/${local.remote_cluster_name}/${var.harbor_chart_name}/values.yaml"
    harbor_db                 = "${var.helm_values_path}/${local.remote_cluster_name}/${var.harbor_chart_name}-db/values.yaml"
    kube_prometheus_stack     = "${var.helm_values_path}/${local.remote_cluster_name}/${var.kube_prometheus_stack_chart_name}/values.yaml"
    prometheus_oauth2_proxy   = "${var.helm_values_path}/${local.remote_cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/values.yaml"
    alertmanager_oauth2_proxy = "${var.helm_values_path}/${local.remote_cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/values.yaml"
    oauth2_proxy_cache        = "${var.helm_values_path}/${local.remote_cluster_name}/${var.oauth2_proxy_cache_chart_name}/values.yaml"
    matomo                    = "${var.helm_values_path}/${local.remote_cluster_name}/${var.matomo_chart_name}/values.yaml"
    matomo_db                 = "${var.helm_values_path}/${local.remote_cluster_name}/${var.matomo_chart_name}-db/values.yaml"
    frontend                  = "${var.helm_values_path}/${local.remote_cluster_name}/${var.frontend_chart_name}/values.yaml"
    backend                   = "${var.helm_values_path}/${local.remote_cluster_name}/${var.backend_chart_name}/values.yaml"
    backend_db                = "${var.helm_values_path}/${local.remote_cluster_name}/${var.backend_chart_name}-db/values.yaml"
    didata_db                 = "${var.helm_values_path}/${local.remote_cluster_name}/${var.didata_chart_name}-db/values.yaml"
    juicefs_csi_driver        = "${var.helm_values_path}/${local.remote_cluster_name}/${var.juicefs_chart_name}-csi-driver/values.yaml"
    juicefs_cache             = "${var.helm_values_path}/${local.remote_cluster_name}/${var.juicefs_chart_name}-cache/values.yaml"
  }

  keycloak_namespace                  = jsondecode(file(local.config_files.keycloak)).namespace
  harbor_namespace                    = jsondecode(file(local.config_files.harbor)).namespace
  prometheus_namespace                = jsondecode(file(local.config_files.kube_prometheus_stack)).namespace
  alertmanager_namespace              = local.prometheus_namespace
  grafana_namespace                   = local.prometheus_namespace
  prometheus_oauth2_proxy_namespace   = jsondecode(file(local.config_files.prometheus_oauth2_proxy)).namespace
  alertmanager_oauth2_proxy_namespace = jsondecode(file(local.config_files.alertmanager_oauth2_proxy)).namespace
  oauth2_proxy_cache_namespace        = jsondecode(file(local.config_files.oauth2_proxy_cache)).namespace
  matomo_namespace                    = jsondecode(file(local.config_files.matomo)).namespace
  matomo_db_namespace                 = jsondecode(file(local.config_files.matomo_db)).namespace
  backend_namespace                   = jsondecode(file(local.config_files.backend)).namespace
  backend_db_namespace                = jsondecode(file(local.config_files.backend_db)).namespace
  i2b2_wildfly_namespace              = jsondecode(file(local.config_files.i2b2_wildfly)).namespace
  i2b2_db_namespace                   = jsondecode(file(local.config_files.i2b2_db)).namespace
  didata_namespace = (
    fileexists(local.config_files.didata)
    ? jsondecode(file(local.config_files.didata)).namespace : null
  )
  didata_db_namespace = (
    fileexists(local.config_files.didata_db)
    ? jsondecode(file(local.config_files.didata_db)).namespace : null
  )
  juicefs_csi_driver_namespace = (
    fileexists(local.config_files.juicefs_csi_driver)
    ? jsondecode(file(local.config_files.juicefs_csi_driver)).namespace : null
  )
  juicefs_s3_gateway_namespace = (
    fileexists(local.config_files.juicefs_s3_gateway)
    ? jsondecode(file(local.config_files.juicefs_s3_gateway)).namespace : null
  )
  juicefs_cache_namespace = (
    fileexists(local.config_files.juicefs_cache)
    ? jsondecode(file(local.config_files.juicefs_cache)).namespace : null
  )

  build_cluster_harbor_values      = file(local.values_files.build_cluster_harbor)
  keycloak_values                  = file(local.values_files.keycloak)
  keycloak_db_values               = file(local.values_files.keycloak_db)
  harbor_values                    = file(local.values_files.harbor_values)
  harbor_db_values                 = file(local.values_files.harbor_db)
  kube_prometheus_stack_values     = file(local.values_files.kube_prometheus_stack)
  prometheus_oauth2_proxy_values   = file(local.values_files.prometheus_oauth2_proxy)
  alertmanager_oauth2_proxy_values = file(local.values_files.alertmanager_oauth2_proxy)
  oauth2_proxy_cache_values        = file(local.values_files.oauth2_proxy_cache)
  matomo_values                    = file(local.values_files.matomo)
  matomo_db_values                 = file(local.values_files.matomo_db)
  frontend_values                  = file(local.values_files.frontend)
  backend_values                   = file(local.values_files.backend)
  backend_db_values                = file(local.values_files.backend_db)
  didata_db_values = (
    fileexists(local.values_files.didata_db)
    ? file(local.values_files.didata_db) : null
  )
  juicefs_csi_driver_values = (
    fileexists(local.values_files.juicefs_csi_driver)
    ? file(local.values_files.juicefs_csi_driver) : null
  )
  juicefs_cache_values = (
    fileexists(local.values_files.juicefs_cache)
    ? file(local.values_files.juicefs_cache) : null
  )

  build_cluster_harbor_values_parsed      = yamldecode(local.build_cluster_harbor_values)
  keycloak_values_parsed                  = yamldecode(local.keycloak_values)
  keycloak_db_values_parsed               = yamldecode(local.keycloak_db_values)
  harbor_values_parsed                    = yamldecode(local.harbor_values)
  harbor_db_values_parsed                 = yamldecode(local.harbor_db_values)
  kube_prometheus_stack_values_parsed     = yamldecode(local.kube_prometheus_stack_values)
  prometheus_oauth2_proxy_values_parsed   = yamldecode(local.prometheus_oauth2_proxy_values)
  alertmanager_oauth2_proxy_values_parsed = yamldecode(local.alertmanager_oauth2_proxy_values)
  matomo_values_parsed                    = yamldecode(local.matomo_values)
  matomo_db_values_parsed                 = yamldecode(local.matomo_db_values)
  frontend_values_parsed                  = yamldecode(local.frontend_values)
  backend_values_parsed                   = yamldecode(local.backend_values)
  backend_db_values_parsed                = yamldecode(local.backend_db_values)
  didata_db_values_parsed = (
    local.didata_db_values != null
    ? yamldecode(local.didata_db_values) : null
  )
  juicefs_csi_driver_values_parsed = (
    local.juicefs_csi_driver_values != null
    ? yamldecode(local.juicefs_csi_driver_values) : null
  )
  juicefs_cache_values_parsed = (
    local.juicefs_cache_values != null
    ? yamldecode(local.juicefs_cache_values) : null
  )

  build_cluster_harbor_url = local.build_cluster_harbor_values_parsed.harbor.externalURL

  keycloak_url            = "https://${local.keycloak_values_parsed.keycloak.ingress.hostname}"
  keycloak_secret_name    = local.keycloak_values_parsed.keycloak.auth.existingSecret
  keycloak_secret_key     = local.keycloak_values_parsed.keycloak.auth.passwordSecretKey
  keycloak_admin_password = data.kubernetes_secret.keycloak_admin_password.data["${local.keycloak_secret_key}"]

  keycloak_db_existing_secret    = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  keycloak_db_user_password_key  = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
  keycloak_db_admin_password_key = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey

  harbor_url                    = local.harbor_values_parsed.harbor.externalURL
  harbor_secret_name            = local.harbor_values_parsed.harbor.existingSecretAdminPassword
  harbor_secret_key             = local.harbor_values_parsed.harbor.existingSecretAdminPasswordKey
  harbor_keycloak_client_secret = jsondecode(data.kubernetes_secret.harbor_oidc.data["${local.harbor_oidc_secret_key}"]).oidc_client_secret
  harbor_admin_password         = data.kubernetes_secret.harbor_admin_password.data["${local.harbor_secret_key}"]
  harbor_oidc_config_env = [
    for env in local.harbor_values_parsed.harbor.core.extraEnvVars :
    env if env.name == "CONFIG_OVERWRITE_JSON"
  ][0]
  harbor_oidc_secret_name = local.harbor_oidc_config_env.valueFrom.secretKeyRef.name
  harbor_oidc_secret_key  = local.harbor_oidc_config_env.valueFrom.secretKeyRef.key
  harbor_oidc_endpoint    = join("/", [local.keycloak_url, "realms", var.keycloak_infra_realm])

  harbor_db_existing_secret    = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  harbor_db_user_password_key  = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey
  harbor_db_admin_password_key = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey

  prometheus_url   = "https://${local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"
  alertmanager_url = "https://${local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"
  grafana_url      = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana["grafana.ini"].server.root_url

  alertmanager_webex_secret_name = try(local.kube_prometheus_stack_values_parsed.alertmanagerConfiguration.webex.credentials.name, "")
  alertmanager_webex_secret_key  = try(local.kube_prometheus_stack_values_parsed.alertmanagerConfiguration.webex.credentials.key, "")

  grafana_oauth_client_secret_name = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana.envValueFrom.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET.secretKeyRef.name
  grafana_oauth_client_secret_key  = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana.envValueFrom.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET.secretKeyRef.key

  matomo_url         = "https://${local.matomo_values_parsed.matomo.ingress.hostname}"
  matomo_secret_name = local.matomo_values_parsed.matomo.existingSecret

  matomo_db_secret_name = local.matomo_db_values_parsed.mariadb.auth.existingSecret
  matomo_db_host        = local.matomo_values_parsed.matomo.externalDatabase.host

  frontend_url = "https://${local.frontend_values_parsed.ingress.hosts.0.host}"

  backend_url = "https://${local.backend_values_parsed.ingress.host}"
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
          username = join("", ["robot$", "${local.remote_cluster_name}"])
          password = module.harbor_config.cluster_robot_password
        }
      ]
      keycloak_openid_client_secret = random_password.backend_keycloak_client_secret.result
      steward_user_password         = random_password.steward_password.result
      backend_s3_enabled            = try(local.backend_values_parsed.main.clients.minio_client.enabled, false)
      juicefs_endpoint              = try(local.backend_values_parsed.main.clients.minio_client.endpoint, "")
      s3_access_key_id              = var.s3_access_key
      s3_secret_key                 = var.s3_secret_key
      s3_bucket_name                = var.s3_bucket_name
    }
  ) # TODO: break down backend secret into multiple small secrets

  backend_db_secret_name      = local.backend_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  backend_db_admin_secret_key = local.backend_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  backend_db_user_secret_key  = local.backend_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey

  didata_url = "https://didata.${local.remote_cluster_name}.chorus-tre.ch/"
  didata_secrets_content = templatefile("${var.templates_path}/didata_secrets.tmpl",
    {
      didata_app_name    = "didata_chorus"
      didata_app_key     = var.didata_app_key
      didata_app_url     = local.didata_url
      didata_db_host     = "${local.remote_cluster_name}-didata-db-mariadb"
      didata_db_database = "didata"
      didata_db_username = "didata"
      didata_db_password = random_password.didata_db_password.result
      didata_jwt_secret  = random_password.didata_jwt_secret.result
    }
  )

  didata_db_secret_name = (
    local.didata_db_values_parsed != null
    ? local.didata_db_values_parsed.mariadb.auth.existingSecret : null
  )

  exclude_config_files_validation = ["didata", "didata_db", "juicefs_csi_driver", "juicefs_s3_gateway", "juicefs_cache"]
  exclude_values_files_validation = ["didata_db", "juicefs_csi_driver", "juicefs_cache"]
}