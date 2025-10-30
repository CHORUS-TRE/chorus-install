# Validate all config files exist
resource "null_resource" "validate_config_files" {
  lifecycle {
    precondition {
      condition = alltrue([
        for k, path in local.config_files :
        can(file(path)) if !contains(local.exclude_config_files_validation, k)
      ])
      error_message = <<-EOT
        Missing configuration files!
        
        ${join("\n        ", [for k, v in local.config_files : "Missing ${k}: ${v}" if !can(file(v)) && !contains(local.exclude_config_files_validation, k)])}
      EOT
    }
  }
}

resource "null_resource" "validate_values_files" {
  lifecycle {
    precondition {
      condition = alltrue([
        for k, path in local.values_files :
        can(file(path)) if !contains(local.exclude_values_files_validation, k)
      ])
      error_message = <<-EOT
        Missing values files!
        
        ${join("\n        ", [for k, v in local.values_files : "Missing ${k}: ${v}" if !can(file(v)) && !contains(local.exclude_values_files_validation, k)])}
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
  pull_replication_registry_name = var.cluster_name
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
    namespace = local.didata_namespace
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
      "reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces" = "kube-system,workbench-operator-system,backend,frontend,workspace[0-9]+"
      "reflector.v1.k8s.emberstack.com/reflection-auto-enabled"       = "true"
    }
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      "auths" = {
        "${local.harbor_url}" = {
          "auth" = base64encode(join("", ["robot$", "${var.remote_cluster_name}", ":${module.harbor_config.cluster_robot_password}"]))
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

  count = var.remote_cluster_webex_access_token != "" ? 1 : 0
}

# JuiceFS

module "juicefs" {
  source = "../modules/juicefs"

  cluster_name                  = var.remote_cluster_name
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
  filename = "../${var.remote_cluster_name}_output.yaml"
  content  = yamlencode(local.output)
}