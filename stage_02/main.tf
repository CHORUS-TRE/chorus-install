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

provider "kubernetes" {
  alias          = "build_cluster"
  config_path    = var.kubeconfig_path
  config_context = var.kubeconfig_context
}

# Cert-Manager CRDs

module "cert_manager_crds" {
  source = "../modules/cert_manager_crds"

  cert_manager_crds_content = local.cert_manager_crds_content
}

# Keycloak

resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = local.keycloak_namespace
  }
}

module "keycloak_db_secret" {
  source = "../modules/db_secret"

  namespace           = local.keycloak_namespace
  secret_name         = local.keycloak_db_secret_name
  db_user_secret_key  = local.keycloak_db_user_secret_key
  db_admin_secret_key = local.keycloak_db_admin_secret_key

  depends_on = [kubernetes_namespace.keycloak]
}

module "keycloak_secret" {
  source = "../modules/keycloak_secret"

  namespace                              = local.keycloak_namespace
  admin_secret_name                      = local.keycloak_secret_name
  admin_secret_key                       = local.keycloak_secret_key
  cluster_type                           = "remote"
  client_credentials_secret_name         = local.keycloak_client_credentials_secret_name
  google_identity_provider_client_id     = var.remote_cluster_google_identity_provider_client_id
  google_identity_provider_client_secret = var.remote_cluster_google_identity_provider_client_secret
  remotestate_encryption_key_secret_name = local.keycloak_remotestate_encryption_key_secret_name

  depends_on = [kubernetes_namespace.keycloak]
}

# Harbor

resource "kubernetes_namespace" "harbor" {
  metadata {
    name = local.harbor_namespace
  }
}

module "harbor_db_secret" {
  source = "../modules/db_secret"

  namespace           = local.harbor_namespace
  secret_name         = local.harbor_db_secret_name
  db_user_secret_key  = local.harbor_db_user_secret_key
  db_admin_secret_key = local.harbor_db_admin_secret_key

  depends_on = [kubernetes_namespace.harbor]
}

module "harbor_secret" {
  source = "../modules/harbor_secret"

  namespace                        = local.harbor_namespace
  core_secret_name                 = local.harbor_core_secret_name
  encryption_key_secret_name       = local.harbor_encryption_key_secret_name
  xsrf_secret_name                 = local.harbor_xsrf_secret_name
  xsrf_secret_key                  = local.harbor_xsrf_secret_key
  admin_username                   = var.harbor_admin_username
  admin_secret_name                = local.harbor_admin_secret_name
  admin_secret_key                 = local.harbor_admin_secret_key
  jobservice_secret_name           = local.harbor_jobservice_secret_name
  jobservice_secret_key            = local.harbor_jobservice_secret_key
  registry_secret_name             = local.harbor_registry_http_secret_name
  registry_secret_key              = local.harbor_registry_http_secret_key
  registry_credentials_secret_name = local.harbor_registry_credentials_secret_name
  oidc_secret_name                 = local.harbor_oidc_secret_name
  oidc_secret_key                  = local.harbor_oidc_secret_key
  oidc_config                      = jsonencode(local.harbor_oidc_config)
  harbor_robots                    = local.harbor_robots

  depends_on = [kubernetes_namespace.harbor]
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

# Prometheus

resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = local.prometheus_namespace
  }
}

# Grafana

resource "random_password" "grafana_admin_password" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "grafana_oauth_client_secret" {
  metadata {
    name      = local.grafana_oauth_client_secret_name
    namespace = local.prometheus_namespace
  }
  data = {
    "admin-password"                           = random_password.grafana_admin_password.result
    "admin-user"                               = var.grafana_admin_username
    "${local.grafana_oauth_client_secret_key}" = module.keycloak_secret.grafana_client_secret
  }

  depends_on = [kubernetes_namespace.prometheus]
}

# Alertmanager

module "alertmanager" {
  source = "../modules/alertmanager"

  webex_secret_name      = local.alertmanager_webex_secret_name
  webex_secret_key       = local.alertmanager_webex_secret_key
  alertmanager_namespace = local.prometheus_namespace
  webex_access_token     = var.remote_cluster_webex_access_token

  count      = var.remote_cluster_webex_access_token != "" ? 1 : 0
  depends_on = [kubernetes_namespace.prometheus]
}

# OAuth2 proxy

module "oauth2_proxy" {
  source = "../modules/oauth2_proxy"

  alertmanager_oauth2_proxy_namespace = local.alertmanager_oauth2_proxy_namespace
  prometheus_oauth2_proxy_namespace   = local.prometheus_oauth2_proxy_namespace
  oauth2_proxy_cache_namespace        = local.oauth2_proxy_cache_namespace

  prometheus_keycloak_client_id          = var.prometheus_keycloak_client_id
  prometheus_keycloak_client_secret      = module.keycloak_secret.prometheus_client_secret
  prometheus_session_storage_secret_name = local.prometheus_session_storage_secret_name
  prometheus_session_storage_secret_key  = local.prometheus_session_storage_secret_key
  prometheus_oidc_secret_name            = local.prometheus_oidc_secret_name

  alertmanager_keycloak_client_id          = var.alertmanager_keycloak_client_id
  alertmanager_keycloak_client_secret      = module.keycloak_secret.alertmanager_client_secret
  alertmanager_session_storage_secret_name = local.alertmanager_session_storage_secret_name
  alertmanager_session_storage_secret_key  = local.alertmanager_session_storage_secret_key
  alertmanager_oidc_secret_name            = local.alertmanager_oidc_secret_name

  oauth2_proxy_cache_session_storage_secret_name = local.oauth2_proxy_cache_session_storage_secret_name
  oauth2_proxy_cache_session_storage_secret_key  = local.oauth2_proxy_cache_session_storage_secret_key

  depends_on = [kubernetes_namespace.keycloak]
}

# Matomo

resource "kubernetes_namespace" "matomo" {
  metadata {
    name = local.matomo_namespace
  }
}

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
  depends_on = [kubernetes_namespace.matomo]
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

  depends_on = [kubernetes_namespace.matomo]
}

# i2b2
# we do not generate the password
# because it is harcoded in the container image

resource "kubernetes_namespace" "i2b2" {
  metadata {
    name = local.i2b2_wildfly_namespace
  }
}

resource "kubernetes_secret" "i2b2_db_secret" {
  metadata {
    name      = "i2b2-postgres-secret"
    namespace = local.i2b2_db_namespace
  }
  data = {
    "postgres-password" = var.i2b2_db_password
  }

  depends_on = [kubernetes_namespace.i2b2]
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

  depends_on = [kubernetes_namespace.i2b2]
}

# didata

resource "kubernetes_namespace" "didata" {
  metadata {
    name = local.didata_namespace
  }
}

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

  count      = var.didata_registry_password != "" ? 1 : 0
  depends_on = [kubernetes_namespace.didata]
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

  count      = var.didata_registry_password != "" ? 1 : 0
  depends_on = [kubernetes_namespace.didata]
}

resource "kubernetes_namespace" "reflector" {
  metadata {
    name = local.reflector_namespace
  }
}

resource "kubernetes_secret" "regcred_didata" {
  metadata {
    name      = "regcred-didata"
    namespace = local.reflector_namespace
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

  count      = var.didata_registry_password != "" ? 1 : 0
  depends_on = [kubernetes_namespace.reflector]
}

# Backend

resource "kubernetes_namespace" "backend" {
  metadata {
    name = local.backend_namespace
  }
}

module "backend_db_secret" {
  source = "../modules/db_secret"

  namespace           = local.backend_db_namespace
  secret_name         = local.backend_db_secret_name
  db_user_secret_key  = local.backend_db_user_secret_key
  db_admin_secret_key = local.backend_db_admin_secret_key

  depends_on = [kubernetes_namespace.backend]
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

resource "kubernetes_secret" "backend_secrets" {
  metadata {
    name      = "${var.remote_cluster_name}-backend"
    namespace = local.backend_namespace
  }
  data = {
    "secrets.yaml" = local.backend_secrets_content
  }

  depends_on = [kubernetes_namespace.backend]
}

# Remote Cluster Connection for ArgoCD running on build cluster (see stage_01)

resource "kubernetes_service_account" "argocd_manager" {
  metadata {
    name      = "argocd-manager"
    namespace = "kube-system"
  }
}

resource "kubernetes_secret" "argocd_manager_token" {
  metadata {
    name      = "argocd-manager-token"
    namespace = kubernetes_service_account.argocd_manager.metadata[0].namespace
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.argocd_manager.metadata.0.name
    }
  }

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "argocd_manager_role_binding" {
  metadata {
    name = "argocd-manager-role-binding"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.argocd_manager.metadata[0].name
    namespace = kubernetes_service_account.argocd_manager.metadata[0].namespace
  }
}

data "kubernetes_secret" "argocd_manager_token" {
  metadata {
    name      = kubernetes_secret.argocd_manager_token.metadata[0].name
    namespace = kubernetes_secret.argocd_manager_token.metadata[0].namespace
  }

  depends_on = [kubernetes_secret.argocd_manager_token]
}

data "kubernetes_config_map" "ca_data" {
  metadata {
    name      = "kube-root-ca.crt"
    namespace = kubernetes_secret.argocd_manager_token.metadata[0].namespace
  }
}

resource "kubernetes_secret" "remote_clusters" {
  provider = kubernetes.build_cluster

  metadata {
    name      = "${var.remote_cluster_name}-cluster"
    namespace = local.argocd_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }

  data = {
    name   = var.remote_cluster_name
    server = var.remote_cluster_server
    config = local.remote_cluster_config
  }

  # We wait for the remote cluster configuration
  # to complete to avoid race condition on
  # namespace creation
  depends_on = [
    module.harbor_db_secret,
    module.harbor_secret,
    module.keycloak_db_secret,
    module.keycloak_secret,
    module.juicefs,
    kubernetes_secret.grafana_oauth_client_secret,
    module.alertmanager,
    module.oauth2_proxy,
    kubernetes_secret.matomo_secret,
    kubernetes_secret.matomo_db_secret,
    kubernetes_secret.i2b2_db_secret,
    kubernetes_secret.i2b2_wildfly,
    kubernetes_secret.didata_env,
    kubernetes_secret.didata_db_secret,
    kubernetes_secret.regcred_didata,
    module.backend_db_secret,
    kubernetes_secret.backend_secrets
  ]
}

locals {
  output = {
    harbor_admin_username = var.harbor_admin_username
    harbor_admin_password = module.harbor_secret.harbor_password
    harbor_url            = local.harbor_url
    harbor_admin_url      = join("/", [local.harbor_url, "account", "sign-in"])

    keycloak_admin_username = var.keycloak_admin_username
    keycloak_admin_password = module.keycloak_secret.admin_password
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
