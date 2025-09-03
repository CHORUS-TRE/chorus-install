locals {
  remote_cluster_name = coalesce(var.remote_cluster_name, var.remote_cluster_kubeconfig_context)
  build_cluster_name  = coalesce(var.cluster_name, var.kubeconfig_context)

  keycloak_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.keycloak_chart_name}/values.yaml")
  keycloak_values_parsed = yamldecode(local.keycloak_values)
  keycloak_namespace     = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.keycloak_chart_name}/config.json")).namespace
  keycloak_secret_name   = local.keycloak_values_parsed.keycloak.auth.existingSecret
  keycloak_secret_key    = local.keycloak_values_parsed.keycloak.auth.passwordSecretKey
  keycloak_url           = "https://${local.keycloak_values_parsed.keycloak.ingress.hostname}"

  harbor_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.harbor_chart_name}/values.yaml")
  harbor_values_parsed = yamldecode(local.harbor_values)
  harbor_namespace     = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.harbor_chart_name}/config.json")).namespace
  harbor_secret_name   = local.harbor_values_parsed.harbor.existingSecretAdminPassword
  harbor_secret_key    = local.harbor_values_parsed.harbor.existingSecretAdminPasswordKey
  harbor_url           = local.harbor_values_parsed.harbor.externalURL

  harbor_oidc_secret = local.harbor_values_parsed.harbor.core.extraEnvVars[
    index(
      local.harbor_values_parsed.harbor.core.extraEnvVars[*].name,
      "CONFIG_OVERWRITE_JSON"
    )
  ].valueFrom.secretKeyRef
  harbor_oidc_secret_name = local.harbor_oidc_secret.name
  harbor_oidc_secret_key  = local.harbor_oidc_secret.key
  harbor_oidc_endpoint    = join("/", [local.keycloak_url, "realms", var.keycloak_infra_realm])

  harbor_keycloak_client_secret = jsondecode(data.kubernetes_secret.harbor_oidc.data["${local.harbor_oidc_secret_key}"]).oidc_client_secret

  keycloak_admin_password = data.kubernetes_secret.keycloak_admin_password.data["${local.keycloak_secret_key}"]
  harbor_admin_password   = data.kubernetes_secret.harbor_admin_password.data["${local.harbor_secret_key}"]

  kube_prometheus_stack_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.kube_prometheus_stack_chart_name}/values.yaml")
  kube_prometheus_stack_values_parsed = yamldecode(local.kube_prometheus_stack_values)
  grafana_url                         = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana["grafana.ini"].server.root_url

  alertmanager_oauth2_proxy_namespace     = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/config.json")).namespace
  alertmanager_oauth2_proxy_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/values.yaml")
  alertmanager_oauth2_proxy_values_parsed = yamldecode(local.alertmanager_oauth2_proxy_values)
  alertmanager_url                        = "https://${local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"

  prometheus_oauth2_proxy_namespace     = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/config.json")).namespace
  prometheus_oauth2_proxy_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/values.yaml")
  prometheus_oauth2_proxy_values_parsed = yamldecode(local.prometheus_oauth2_proxy_values)
  prometheus_url                        = "https://${local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"

  oauth2_proxy_cache_namespace = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.oauth2_proxy_cache_chart_name}/config.json")).namespace
  oauth2_proxy_cache_values    = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.oauth2_proxy_cache_chart_name}/values.yaml")

  grafana_namespace                = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.kube_prometheus_stack_chart_name}/config.json")).namespace
  grafana_oauth_client_secret_name = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana.envValueFrom.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET.secretKeyRef.name
  grafana_oauth_client_secret_key  = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana.envValueFrom.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET.secretKeyRef.key

  matomo_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.matomo_chart_name}/values.yaml")
  matomo_values_parsed = yamldecode(local.matomo_values)
  matomo_url           = "https://${local.matomo_values_parsed.matomo.ingress.hostname}"
  matomo_namespace     = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.matomo_chart_name}/config.json")).namespace
  matomo_secret_name   = local.matomo_values_parsed.matomo.existingSecret

  matomo_db_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.matomo_chart_name}-db/values.yaml")
  matomo_db_values_parsed = yamldecode(local.matomo_db_values)
  matomo_db_namespace     = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.matomo_chart_name}-db/config.json")).namespace
  matomo_db_secret_name   = local.matomo_db_values_parsed.mariadb.auth.existingSecret
  matomo_db_host          = local.matomo_values_parsed.matomo.externalDatabase.host


  backend_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.backend_chart_name}/values.yaml")
  backend_values_parsed = yamldecode(local.backend_values)
  backend_url           = "https://${local.backend_values_parsed.ingress.host}"
  backend_namespace     = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.backend_chart_name}/config.json")).namespace
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
      k8s_client_ca                          = indent(6, trimspace(base64decode(var.remote_cluster_ca_data)))
      k8s_client_token                       = var.remote_cluster_bearer_token
      k8s_client_image_pull_secrets = [
        {
          registry = "harbor.${local.build_cluster_name}.chorus-tre.ch"
          username = join("", ["robot$", "${local.build_cluster_name}"])
          password = module.harbor_config.build_robot_password
        },
        {
          registry = "harbor.${local.remote_cluster_name}.chorus-tre.ch"
          username = join("", ["robot$", "${local.remote_cluster_name}"])
          password = module.harbor_config.cluster_robot_password
        }
      ]
      keycloak_openid_client_secret = random_password.backend_keycloak_client_secret.result
      steward_user_password         = random_password.steward_password.result
    }
  ) # TODO: break down backend secret into multiple small secrets

  backend_db_namespace        = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.backend_chart_name}-db/config.json")).namespace
  backend_db_values           = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.backend_chart_name}-db/values.yaml")
  backend_db_values_parsed    = yamldecode(local.backend_db_values)
  backend_db_secret_name      = local.backend_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  backend_db_admin_secret_key = local.backend_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  backend_db_user_secret_key  = local.backend_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey

  i2b2_wildfly_namespace = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.i2b2_chart_name}-wildfly/config.json")).namespace
  i2b2_db_namespace      = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.i2b2_chart_name}-db/config.json")).namespace

  didata_registry_password = coalesce(var.didata_registry_password, "do-not-install")

  didata_secrets_content = templatefile("${var.templates_path}/didata_secrets.tmpl",
    {
      didata_app_name    = "didata_chorus"
      didata_app_key     = var.didata_app_key
      didata_app_url     = "https://didata.${local.remote_cluster_name}.chorus-tre.ch/"
      didata_db_host     = "${local.remote_cluster_name}-didata-db-mariadb"
      didata_db_database = "didata"
      didata_db_username = "didata"
      didata_db_password = random_password.didata_db_password.result
      didata_jwt_secret  = random_password.didata_jwt_secret.result
    }
  )

  didata_db_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.didata_chart_name}-db/values.yaml")
  didata_db_values_parsed = yamldecode(local.didata_db_values)
  didata_db_namespace     = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.didata_chart_name}-db/config.json")).namespace
  didata_db_secret_name   = local.didata_db_values_parsed.mariadb.auth.existingSecret
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
  valid_redirect_uris = [join("/", [local.backend_url, "*"]), join("/", ["https://${local.remote_cluster_name}.chorus-tre.ch", "*"])]
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

  build_robot_username   = local.build_cluster_name
  cluster_robot_username = var.remote_cluster_name
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
  special = true
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
  special = true
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
## TODO: address the fact that password seems hardcoded somewhere
resource "random_password" "i2b2_pg_pass" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "i2b2_db_secret" {
  metadata {
    name      = "i2b2-postgres-secret"
    namespace = local.i2b2_db_namespace
  }

  data = {
    "postgres-password" = random_password.i2b2_pg_pass.result
  }
}

# i2b2-wildfly

resource "random_password" "ds_crc_pass" {
  length  = 32
  special = false
}

resource "random_password" "ds_hive_pass" {
  length  = 32
  special = false
}

resource "random_password" "ds_ont_pass" {
  length  = 32
  special = false
}

resource "random_password" "ds_password" {
  length  = 32
  special = false
}

resource "random_password" "ds_pm_pass" {
  length  = 32
  special = false
}

resource "random_password" "ds_wd_pass" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "i2b2_wildfly" {
  metadata {
    name      = "i2b2-wildfly-secret"
    namespace = local.i2b2_wildfly_namespace
  }

  data = {
    ds_crc_pass  = random_password.ds_crc_pass.result
    ds_hive_pass = random_password.ds_hive_pass.result
    ds_ont_pass  = random_password.ds_ont_pass.result
    ds_password  = random_password.ds_password.result
    ds_pm_pass   = random_password.ds_pm_pass.result
    ds_wd_pass   = random_password.ds_wd_pass.result
    pg_pass      = random_password.i2b2_pg_pass.result
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

  count = local.didata_registry_password == "do-not-install" ? 0 : 1
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

  count = local.didata_registry_password == "do-not-install" ? 0 : 1
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
          "auth" = base64encode(join(":", [var.didata_registry_username, local.didata_registry_password]))
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"

  count = local.didata_registry_password == "do-not-install" ? 0 : 1
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