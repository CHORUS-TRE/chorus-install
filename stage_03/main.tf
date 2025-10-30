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

# Random passwords

resource "random_password" "harbor_keycloak_client_secret" {
  length  = 32
  special = false
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

  namespace   = local.keycloak_namespace
  secret_name = local.keycloak_secret_name
  secret_key  = local.keycloak_secret_key

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

  depends_on = [kubernetes_namespace.harbor]
}

# Remote Cluster Connection for ArgoCD running on chorus-build

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
    module.keycloak_secret
  ]
}