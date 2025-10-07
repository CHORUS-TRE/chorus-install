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
    didata                    = "${var.helm_values_path}/${local.remote_cluster_name}/${var.didata_chart_name}/values.yaml"
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
  didata_db_namespace                 = jsondecode(file(local.config_files.didata_db)).namespace
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
  didata_db_values                 = file(local.values_files.didata_db)
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
  didata_db_values_parsed                 = yamldecode(local.didata_db_values)
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

  didata_db_secret_name = local.didata_db_values_parsed.mariadb.auth.existingSecret
}

# Validate all config files exist
resource "null_resource" "validate_config_files" {
  lifecycle {
    precondition {
      condition     = alltrue([for path in values(local.config_files) : can(file(path))])
      error_message = <<-EOT
        Missing configuration files!
        
        ${join("\n        ", [for k, v in local.config_files : "Missing ${k}: ${v}" if !can(file(v))])}
      EOT
    }
  }
}

# Validate all values files exist
resource "null_resource" "validate_values_files" {
  lifecycle {
    precondition {
      condition     = alltrue([for path in values(local.values_files) : can(file(path))])
      error_message = <<-EOT
        Missing values files!
        
        ${join("\n        ", [for k, v in local.values_files : "Missing ${k}: ${v}" if !can(file(v))])}
      EOT
    }
  }
}

# Providers

provider "keycloak" {
  alias     = "kcadmin-provider"
  client_id = "admin-cli"
  username  = var.keycloak_admin_username
  password  = local.keycloak_admin_password
  url       = local.keycloak_url
  # Ignoring certificate errors
  # because it might take some times
  # for certificates to be signed
  # by a trusted authority
  tls_insecure_skip_verify = true
}

provider "harbor" {
  alias    = "harboradmin-provider"
  url      = local.harbor_url
  username = var.harbor_admin_username
  password = local.harbor_admin_password
  # Ignoring certificate errors
  # because it might take some times
  # for certificates to be signed
  # by a trusted authority
  insecure = true
}

# Random passwords

resource "random_password" "harbor_keycloak_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "grafana_keycloak_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "alertmanager_keycloak_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "prometheus_keycloak_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "backend_keycloak_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "matomo_keycloak_client_secret" {
  length  = 32
  special = false
}

data "kubernetes_secret" "harbor_oidc" {
  metadata {
    name      = local.harbor_oidc_secret_name
    namespace = local.harbor_namespace
  }
}

data "kubernetes_secret" "keycloak_admin_password" {
  metadata {
    name      = local.keycloak_secret_name
    namespace = local.keycloak_namespace
  }
}

data "kubernetes_secret" "harbor_admin_password" {
  metadata {
    name      = local.harbor_secret_name
    namespace = local.harbor_namespace
  }
}

# Keycloak

module "remote_cluster_keycloak_config" {
  source = "../modules/remote_cluster_keycloak_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  admin_id           = var.keycloak_admin_username
  infra_realm_name   = var.keycloak_infra_realm
  backend_realm_name = var.keycloak_backend_realm

  google_identity_provider_client_id     = var.google_identity_provider_client_id
  google_identity_provider_client_secret = var.google_identity_provider_client_secret
}

module "keycloak_harbor_client_config" {
  source = "../modules/keycloak_generic_client_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  realm_id            = module.remote_cluster_keycloak_config.infra_realm_id
  client_id           = var.harbor_keycloak_client_id
  client_secret       = local.harbor_keycloak_client_secret
  root_url            = local.harbor_url
  base_url            = var.harbor_keycloak_base_url
  admin_url           = local.harbor_url
  web_origins         = [local.harbor_url]
  valid_redirect_uris = [join("/", [local.harbor_url, "c/oidc/callback"])]
  client_group        = var.harbor_keycloak_oidc_admin_group
}

module "keycloak_grafana_client_config" {
  source = "../modules/keycloak_grafana_client_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  realm_id            = module.remote_cluster_keycloak_config.infra_realm_id
  client_id           = var.grafana_keycloak_client_id
  client_secret       = random_password.grafana_keycloak_client_secret.result
  root_url            = local.grafana_url
  base_url            = var.grafana_keycloak_base_url
  admin_url           = local.grafana_url
  web_origins         = [local.grafana_url]
  valid_redirect_uris = [join("/", [local.grafana_url, "login/generic_oauth"])]
  client_group        = var.grafana_keycloak_oidc_admin_group
}

module "keycloak_alertmanager_client_config" {
  source = "../modules/keycloak_oauth2_proxy_client_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  realm_id            = module.remote_cluster_keycloak_config.infra_realm_id
  client_id           = var.alertmanager_keycloak_client_id
  client_secret       = random_password.alertmanager_keycloak_client_secret.result
  root_url            = local.alertmanager_url
  base_url            = var.alertmanager_keycloak_base_url
  admin_url           = local.alertmanager_url
  web_origins         = [local.alertmanager_url]
  valid_redirect_uris = [join("/", [local.alertmanager_url, "*"])]
}

module "keycloak_prometheus_client_config" {
  source = "../modules/keycloak_oauth2_proxy_client_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  realm_id            = module.remote_cluster_keycloak_config.infra_realm_id
  client_id           = var.prometheus_keycloak_client_id
  client_secret       = random_password.prometheus_keycloak_client_secret.result
  root_url            = local.prometheus_url
  base_url            = var.prometheus_keycloak_base_url
  admin_url           = local.prometheus_url
  web_origins         = [local.prometheus_url]
  valid_redirect_uris = [join("/", [local.prometheus_url, "*"]), join("/", [local.alertmanager_url, "*"])]
}

module "keycloak_backend_client_config" {
  source = "../modules/keycloak_backend_client_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  realm_id            = module.remote_cluster_keycloak_config.backend_realm_id
  client_id           = var.backend_keycloak_client_id
  client_secret       = random_password.backend_keycloak_client_secret.result
  root_url            = local.backend_url
  base_url            = var.backend_keycloak_base_url
  admin_url           = local.backend_url
  web_origins         = [local.backend_url]
  valid_redirect_uris = [join("/", [local.backend_url, "*"]), join("/", [local.frontend_url, "*"])]
}

module "keycloak_matomo_client_config" {
  source = "../modules/keycloak_generic_client_config"

  providers = {
    keycloak = keycloak.kcadmin-provider
  }

  realm_id            = module.remote_cluster_keycloak_config.infra_realm_id
  client_id           = var.matomo_keycloak_client_id
  client_secret       = random_password.matomo_keycloak_client_secret.result
  root_url            = local.matomo_url
  base_url            = var.matomo_keycloak_base_url
  admin_url           = local.matomo_url
  web_origins         = [local.matomo_url]
  valid_redirect_uris = [join("/", [local.matomo_url, "index.php?module=LoginOIDC&action=callback&provider=oidc"])]
}

# Harbor

module "harbor_config" {
  source = "../modules/remote_cluster_harbor_config"

  providers = {
    harbor = harbor.harboradmin-provider
  }

  cluster_robot_username         = var.remote_cluster_name
  pull_replication_registry_name = local.build_cluster_name
  pull_replication_registry_url  = local.build_cluster_harbor_url
}

# Grafana

resource "random_password" "grafana_admin_password" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "grafana_oauth_client_secret" {
  metadata {
    name      = local.grafana_oauth_client_secret_name
    namespace = local.grafana_namespace
  }

  data = {
    "admin-password"                           = random_password.grafana_admin_password.result
    "admin-user"                               = var.grafana_admin_username
    "${local.grafana_oauth_client_secret_key}" = random_password.grafana_keycloak_client_secret.result
  }
}

# OAuth2 proxy

module "oauth2_proxy" {
  source = "../modules/oauth2_proxy"

  alertmanager_oauth2_proxy_values = local.alertmanager_oauth2_proxy_values
  prometheus_oauth2_proxy_values   = local.prometheus_oauth2_proxy_values
  oauth2_proxy_cache_values        = local.oauth2_proxy_cache_values

  prometheus_oauth2_proxy_namespace   = local.prometheus_oauth2_proxy_namespace
  alertmanager_oauth2_proxy_namespace = local.alertmanager_oauth2_proxy_namespace
  oauth2_proxy_cache_namespace        = local.oauth2_proxy_cache_namespace

  prometheus_keycloak_client_secret   = random_password.prometheus_keycloak_client_secret.result
  alertmanager_keycloak_client_secret = random_password.alertmanager_keycloak_client_secret.result

  alertmanager_keycloak_client_id = var.alertmanager_keycloak_client_id
  prometheus_keycloak_client_id   = var.prometheus_keycloak_client_id
}

# Backend

module "backend_db_secret" {
  source = "../modules/db_secret"

  namespace           = local.backend_db_namespace
  secret_name         = local.backend_db_secret_name
  db_user_secret_key  = local.backend_db_user_secret_key
  db_admin_secret_key = local.backend_db_admin_secret_key
}

resource "random_password" "jwt_signature" {
  length  = 32
  special = false
}

resource "random_password" "metrics_password" {
  length  = 32
  special = false
}

resource "tls_private_key" "chorus_backend_daemon" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "random_password" "steward_password" {
  length  = 32
  special = false
}

# The secret name is hardcoded in the following
# block because the Backend Helm chart does not
# allow to rename it

resource "kubernetes_secret" "backend_secrets" {

  metadata {
    name      = "backend-secrets"
    namespace = local.backend_namespace

  }

  data = {
    "secrets.yaml" = local.backend_secrets_content
  }
}

# Matomo

resource "random_password" "matomo_password" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "matomo_secret" {

  metadata {
    name      = local.matomo_secret_name
    namespace = local.matomo_namespace

  }

  data = {
    matomo-password = random_password.matomo_password.result
  }
}

resource "random_password" "matomo_db_password" {
  length  = 32
  special = false
}

resource "random_password" "matomo_db_replication_password" {
  length  = 32
  special = false
}

resource "random_password" "matomo_db_root_password" {
  length  = 32
  special = false
}

# TODO: Currently, the matomo chart looks for 
# the key "db-password". Let's check if this 
# can be changed so that we don't have to duplicate
# the mariadb password twice
resource "kubernetes_secret" "matomo_db_secret" {

  metadata {
    name      = local.matomo_db_secret_name
    namespace = local.matomo_db_namespace

  }

  data = {
    db-password                  = random_password.matomo_db_password.result
    mariadb-password             = random_password.matomo_db_password.result
    mariadb-replication-password = random_password.matomo_db_replication_password.result
    mariadb-root-password        = random_password.matomo_db_root_password.result
  }
}

# i2b2
# we do not generate the password
# because it is harcoded in the container image

resource "kubernetes_secret" "i2b2_db_secret" {
  metadata {
    name      = "i2b2-postgres-secret"
    namespace = local.i2b2_db_namespace
  }

  data = {
    "postgres-password" = var.i2b2_db_password
  }
}

# i2b2-wildfly

resource "kubernetes_secret" "i2b2_wildfly" {
  metadata {
    name      = "i2b2-wildfly-secret"
    namespace = local.i2b2_wildfly_namespace
  }

  data = {
    ds_crc_pass  = var.i2b2_db_password
    ds_hive_pass = var.i2b2_db_password
    ds_ont_pass  = var.i2b2_db_password
    ds_password  = var.i2b2_db_password
    ds_pm_pass   = var.i2b2_db_password
    ds_wd_pass   = var.i2b2_db_password
    pg_pass      = var.i2b2_db_password
  }
}

# didata

resource "random_password" "didata_db_password" {
  length  = 32
  special = false
}

resource "random_password" "didata_db_replication_password" {
  length  = 32
  special = false
}

resource "random_password" "didata_db_root_password" {
  length  = 32
  special = false
}

resource "random_password" "didata_jwt_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "didata_env" {
  metadata {
    name      = "didata-env"
    namespace = "didata"
  }

  data = {
    "didata.env" = local.didata_secrets_content
  }

  count = var.didata_registry_password != "" ? 1 : 0
}

resource "kubernetes_secret" "didata_db_secret" {

  metadata {
    name      = local.didata_db_secret_name
    namespace = local.didata_db_namespace

  }

  data = {
    mariadb-password             = random_password.didata_db_password.result
    mariadb-replication-password = random_password.didata_db_replication_password.result
    mariadb-root-password        = random_password.didata_db_root_password.result
  }

  count = var.didata_registry_password != "" ? 1 : 0
}

resource "kubernetes_secret" "regcred_didata" {
  metadata {
    name      = "regcred-didata"
    namespace = "reflector"
    annotations = {
      "reflector.v1.k8s.emberstack.com/reflection-allowed"            = "true"
      "reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces" = "didata"
      "reflector.v1.k8s.emberstack.com/reflection-auto-enabled"       = "true"
    }
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      "auths" = {
        "https://index.docker.io/v1/" = {
          "auth" = base64encode(join(":", [var.didata_registry_username, var.didata_registry_password]))
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"

  count = var.didata_registry_password != "" ? 1 : 0
}

# RegCred

resource "kubernetes_secret" "regcred" {
  metadata {
    name      = "regcred"
    namespace = "reflector"
    annotations = {
      "reflector.v1.k8s.emberstack.com/reflection-allowed"            = "true"
      "reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces" = "workbench-operator-system,backend,frontend,workspace[0-9]+"
      "reflector.v1.k8s.emberstack.com/reflection-auto-enabled"       = "true"
    }
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      "auths" = {
        "${local.harbor_url}" = {
          "auth" = base64encode(join("", ["robot$", "${local.remote_cluster_name}", ":${module.harbor_config.cluster_robot_password}"]))
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

# Alertmanager

module "alertmanager" {
  source = "../modules/alertmanager"

  webex_secret_name      = local.alertmanager_webex_secret_name
  webex_secret_key       = local.alertmanager_webex_secret_key
  alertmanager_namespace = local.alertmanager_namespace
  webex_access_token     = var.remote_cluster_webex_access_token
}

# JuiceFS

module "juicefs" {
  source = "../modules/juicefs"

  cluster_name                  = local.remote_cluster_name
  juicefs_cache_secret_name     = local.juicefs_cache_values_parsed.valkey.auth.existingSecret
  juicefs_cache_secret_key      = local.juicefs_cache_values_parsed.valkey.auth.existingSecretPasswordKey
  juicefs_cache_namespace       = local.juicefs_cache_namespace
  juicefs_dashboard_secret_name = local.juicefs_csi_driver_values_parsed.juicefs-csi-driver.dashboard.auth.existingSecret
  juicefs_csi_driver_namespace  = local.juicefs_csi_driver_namespace
  juicefs_dashboard_username    = var.juicefs_dashboard_username
  s3_access_key                 = var.s3_access_key
  s3_secret_key                 = var.s3_secret_key
  s3_endpoint                   = var.s3_endpoint
  s3_bucket_name                = var.s3_bucket_name

  count = var.s3_secret_key == "" ? 0 : 1
}

locals {
  output = {
    harbor_admin_username = var.harbor_admin_username
    harbor_admin_password = local.harbor_admin_password
    harbor_url            = local.harbor_url
    harbor_admin_url      = join("/", [local.harbor_url, "account", "sign-in"])

    keycloak_admin_username = var.keycloak_admin_username
    keycloak_admin_password = local.keycloak_admin_password
    keycloak_url            = local.keycloak_url

    prometheus_url         = local.prometheus_url
    alertmanager_url       = local.alertmanager_url
    grafana_url            = local.grafana_url
    grafana_admin_username = var.grafana_admin_username
    grafana_admin_password = random_password.grafana_admin_password.result

    matomo_url   = local.matomo_url
    frontend_url = local.frontend_url
    backend_url  = local.backend_url
    didata_url   = local.didata_url

    juicefs_enabled = var.s3_secret_key != "" ? true : false
    didata_enabled  = var.didata_registry_password != "" ? true : false
  }
}

resource "local_file" "stage_04_output" {
  filename = "../${local.remote_cluster_name}_output.yaml"
  content  = yamlencode(local.output)
}