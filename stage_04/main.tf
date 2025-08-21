locals {
  remote_cluster_name = coalesce(var.remote_cluster_name, var.remote_cluster_kubeconfig_context)

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

  matomo_db_values         = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.matomo_chart_name}-db/values.yaml")
  matomo_db_values_parsed  = yamldecode(local.matomo_db_values)
  matomo_db_namespace      = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.matomo_chart_name}-db/config.json")).namespace
  matomo_db_secret_name    = local.matomo_db_values_parsed.mariadb.auth.existingSecret
  matomo_db_configmap_name = local.matomo_db_values_parsed.mariadb.initdbScriptsConfigMap
  matomo_db_host           = local.matomo_values_parsed.matomo.externalDatabase.host


  backend_values        = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.backend_chart_name}/values.yaml")
  backend_values_parsed = yamldecode(local.backend_values)
  backend_url           = "https://${local.backend_values_parsed.ingress.host}"
  backend_namespace     = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.backend_chart_name}/config.json")).namespace
  backend_secrets_content = templatefile("${path.module}/backend_secrets.tmpl",
    {
      daemon_jwt_secret                      = random_password.jwt_signature.result
      daemon_metrics_authentication_enabled  = "true"
      daemon_metrics_authentication_username = "prometheus"
      daemon_metrics_authentication_password = random_password.metrics_password.result
      daemon_private_key                     = trimspace(tls_private_key.chorus_backend_daemon.private_key_pem)
      storage_datastores_chorus_password     = random_password.datastores_password.result
      k8s_client_is_watcher                  = "true"
      k8s_client_api_server                  = var.remote_cluster_server
      k8s_client_ca                          = var.remote_cluster_ca_data
      k8s_client_token                       = var.remote_cluster_bearer_token
      k8s_client_image_pull_secrets = [
        {
          registry = "harbor.${var.cluster_name}.chorus-tre.ch"
          username = join("", ["robot$", "${var.cluster_name}"])
          password = module.harbor_config.build_robot_password
        },
        {
          registry = "harbor.${var.remote_cluster_name}.chorus-tre.ch"
          username = join("", ["robot$", "${var.remote_cluster_name}"])
          password = module.harbor_config.cluster_robot_password
        }
      ]
      keycloak_openid_client_secret = random_password.backend_keycloak_client_secret.result
      steward_user_password         = random_password.steward_password.result
    }
  )

  backend_db_namespace        = jsondecode(file("${var.helm_values_path}/${local.remote_cluster_name}/${var.backend_chart_name}-db/config.json")).namespace
  backend_db_values           = file("${var.helm_values_path}/${local.remote_cluster_name}/${var.backend_chart_name}-db/values.yaml")
  backend_db_values_parsed    = yamldecode(local.backend_db_values)
  backend_db_secret_name      = local.backend_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  backend_db_admin_secret_key = local.backend_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  backend_db_user_secret_key  = local.backend_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey

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
  valid_redirect_uris = [join("/", [local.backend_url, "*"]), join("/", ["https://${var.remote_cluster_name}.chorus-tre.ch", "*"])]
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

  build_robot_username   = "harbor-build"
  cluster_robot_username = "chorus"
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

# backend-service-account service account in backend namespace
# >> backend/values.deployment.serviceAccountName
# secrets:
# - name: backend-service-account-secret

# backend-postgresql secret in backend namespace
# admin-password:
# postgres-password:
# replication-password:
# user-password:

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

resource "random_password" "datastores_password" {
  length  = 32
  special = true
}

resource "random_password" "steward_password" {
  length  = 32
  special = true
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

resource "random_password" "mariadb_password" {
  length  = 32
  special = false
}

resource "random_password" "mariadb_replication_password" {
  length  = 32
  special = false
}

resource "random_password" "mariadb_root_password" {
  length  = 32
  special = false
}

# TODO: Currently, the matomo chart looks for 
# the key "db-password". Let's check if this 
# can be changed so that we don't have to duplicate
# the mariadb password twice
resource "kubernetes_secret" "mariadb_secret" {

  metadata {
    name      = local.matomo_db_secret_name
    namespace = local.matomo_db_namespace

  }

  data = {
    db-password                  = random_password.mariadb_password.result
    mariadb-password             = random_password.mariadb_password.result
    mariadb-replication-password = random_password.mariadb_replication_password.result
    mariadb-root-password        = random_password.mariadb_root_password.result
  }
}

/*
resource "kubernetes_config_map" "matomo_db_initdb" {
  metadata {
    name = local.matomo_db_configmap_name
    namespace = local.matomo_db_namespace
  }
  data = {
    "initdb.sh" =<<EOT
      #!/bin/sh
      set -eu
      case "$(hostname)" in
        *mariadb-0)
          echo "Running DB init on primary node"
          /opt/bitnami/mariadb/bin/mariadb -P 3306 -u root -p"$MARIADB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS bitnami_matomo"
          ;;
      esac
      EOT
  }
}
*/

resource "kubernetes_job" "matomo_db_init" {
  metadata {
    name      = "matomo-db-init"
    namespace = local.matomo_db_namespace
  }

  spec {
    backoff_limit = 100

    template {
      metadata {}
      spec {
        restart_policy = "OnFailure"

        container {
          name  = "matomo-db-init"
          image = "bitnami/mariadb:12.0.2"

          command = [
            "sh", "-c", 
            <<EOT
              # Wait for MariaDB
              until mariadb-admin ping \
                --host=${local.matomo_db_host} \
                --port=3306 \
                --user=root \
                --password="$MARIADB_ROOT_PASSWORD" \
                --silent; do
                echo "Waiting for MariaDB to be ready..."
                sleep 5
              done

              # Run init SQL
              mariadb --host=${local.matomo_db_host} \
                      --port=3306 \
                      --user=root \
                      --password="$MARIADB_ROOT_PASSWORD" \
                      -e "CREATE DATABASE IF NOT EXISTS bitnami_matomo; \
                          CREATE USER IF NOT EXISTS 'bn_matomo'@'%'; \
                          ALTER USER 'bn_matomo'@'%' IDENTIFIED BY '$${MARIADB_PASSWORD}'; \
                          GRANT ALL PRIVILEGES ON bitnami_matomo.* TO 'bn_matomo'@'%'; \
                          FLUSH PRIVILEGES;"
            EOT
          ]

          env {
            name = "MARIADB_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = local.matomo_db_secret_name
                key  = "mariadb-root-password"
              }
            }
          }

          env {
            name = "MARIADB_PASSWORD"
            value_from {
              secret_key_ref {
                name = local.matomo_db_secret_name
                key  = "mariadb-password"
              }
            }
          }
        }
      }
    }
  }
}

# Web-UI / Frontend

# regcred secret in frontend namespace
# .dockerconfigjson
# or is this created by reflector?!