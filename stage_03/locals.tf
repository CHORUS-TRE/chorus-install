locals {
  remote_cluster_config = jsonencode({
    bearerToken = data.kubernetes_secret.argocd_manager_token.data.token
    tlsClientConfig = {
      insecure = var.remote_cluster_insecure
      caData   = base64encode(data.kubernetes_config_map.ca_data.data["ca.crt"])
    }
  })

  cert_manager_crds_content = file("${var.cert_manager_crds_path}/${var.remote_cluster_name}/cert-manager.crds.yaml")

  config_files = {
    # ArgoCD runs on build cluster
    argocd = "${var.helm_values_path}/${var.cluster_name}/${var.argocd_chart_name}/config.json"
    # Remote cluster resources
    keycloak = "${var.helm_values_path}/${var.remote_cluster_name}/${var.keycloak_chart_name}/config.json"
    harbor   = "${var.helm_values_path}/${var.remote_cluster_name}/${var.harbor_chart_name}/config.json"
  }

  values_files = {
    keycloak                  = "${var.helm_values_path}/${var.remote_cluster_name}/${var.keycloak_chart_name}/values.yaml"
    keycloak_db               = "${var.helm_values_path}/${var.remote_cluster_name}/${var.keycloak_chart_name}-db/values.yaml"
    harbor                    = "${var.helm_values_path}/${var.remote_cluster_name}/${var.harbor_chart_name}/values.yaml"
    harbor_db                 = "${var.helm_values_path}/${var.remote_cluster_name}/${var.harbor_chart_name}-db/values.yaml"
    kube_prometheus_stack     = "${var.helm_values_path}/${var.remote_cluster_name}/${var.kube_prometheus_stack_chart_name}/values.yaml"
    prometheus_oauth2_proxy   = "${var.helm_values_path}/${var.remote_cluster_name}/${var.prometheus_oauth2_proxy_chart_name}/values.yaml"
    alertmanager_oauth2_proxy = "${var.helm_values_path}/${var.remote_cluster_name}/${var.alertmanager_oauth2_proxy_chart_name}/values.yaml"
    backend                   = "${var.helm_values_path}/${var.remote_cluster_name}/${var.backend_chart_name}/values.yaml"
  }

  keycloak_namespace = jsondecode(file(local.config_files.keycloak)).namespace
  harbor_namespace   = jsondecode(file(local.config_files.harbor)).namespace
  argocd_namespace   = jsondecode(file(local.config_files.argocd)).namespace

  keycloak_values                  = file(local.values_files.keycloak)
  keycloak_db_values               = file(local.values_files.keycloak_db)
  harbor_values                    = file(local.values_files.harbor)
  harbor_db_values                 = file(local.values_files.harbor_db)
  kube_prometheus_stack_values     = file(local.values_files.kube_prometheus_stack)
  prometheus_oauth2_proxy_values   = file(local.values_files.prometheus_oauth2_proxy)
  alertmanager_oauth2_proxy_values = file(local.values_files.alertmanager_oauth2_proxy)
  backend_values                   = file(local.values_files.backend)

  keycloak_values_parsed                  = yamldecode(local.keycloak_values)
  keycloak_db_values_parsed               = yamldecode(local.keycloak_db_values)
  harbor_values_parsed                    = yamldecode(local.harbor_values)
  harbor_db_values_parsed                 = yamldecode(local.harbor_db_values)
  kube_prometheus_stack_values_parsed     = yamldecode(local.kube_prometheus_stack_values)
  prometheus_oauth2_proxy_values_parsed   = yamldecode(local.prometheus_oauth2_proxy_values)
  alertmanager_oauth2_proxy_values_parsed = yamldecode(local.alertmanager_oauth2_proxy_values)
  backend_values_parsed                   = yamldecode(local.backend_values)

  keycloak_secret_name = local.keycloak_values_parsed.keycloak.auth.existingSecret
  keycloak_secret_key  = local.keycloak_values_parsed.keycloak.auth.passwordSecretKey
  keycloak_url         = "https://${local.keycloak_values_parsed.keycloak.ingress.hostname}"

  keycloak_db_secret_name      = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  keycloak_db_admin_secret_key = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  keycloak_db_user_secret_key  = local.keycloak_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey

  harbor_core_secret_name = local.harbor_values_parsed.harbor.core.existingSecret
  harbor_url              = local.harbor_values_parsed.harbor.externalURL

  harbor_db_secret_name      = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.existingSecret
  harbor_db_admin_secret_key = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.adminPasswordKey
  harbor_db_user_secret_key  = local.harbor_db_values_parsed.postgresql.global.postgresql.auth.secretKeys.userPasswordKey

  harbor_encryption_key_secret_name       = local.harbor_values_parsed.harbor.existingSecretSecretKey
  harbor_xsrf_secret_name                 = local.harbor_values_parsed.harbor.core.existingXsrfSecret
  harbor_xsrf_secret_key                  = local.harbor_values_parsed.harbor.core.existingXsrfSecretKey
  harbor_admin_secret_name                = local.harbor_values_parsed.harbor.existingSecretAdminPassword
  harbor_admin_secret_key                 = local.harbor_values_parsed.harbor.existingSecretAdminPasswordKey
  harbor_jobservice_secret_name           = local.harbor_values_parsed.harbor.jobservice.existingSecret
  harbor_jobservice_secret_key            = local.harbor_values_parsed.harbor.jobservice.existingSecretKey
  harbor_registry_http_secret_name        = local.harbor_values_parsed.harbor.registry.existingSecret
  harbor_registry_http_secret_key         = local.harbor_values_parsed.harbor.registry.existingSecretKey
  harbor_registry_credentials_secret_name = local.harbor_values_parsed.harbor.registry.credentials.existingSecret

  harbor_oidc_config_env = [
    for env in local.harbor_values_parsed.harbor.core.extraEnvVars :
    env if env.name == "CONFIG_OVERWRITE_JSON"
  ][0]
  harbor_oidc_secret_name = local.harbor_oidc_config_env.valueFrom.secretKeyRef.name
  harbor_oidc_secret_key  = local.harbor_oidc_config_env.valueFrom.secretKeyRef.key
  harbor_oidc_endpoint    = join("/", [local.keycloak_url, "realms", var.keycloak_infra_realm])

  harbor_oidc_config = jsondecode(templatefile("${var.templates_path}/harbor_oidc.tmpl",
    {
      oidc_endpoint      = local.harbor_oidc_endpoint
      oidc_client_id     = var.harbor_keycloak_client_id
      oidc_client_secret = random_password.harbor_keycloak_client_secret.result
      oidc_admin_group   = var.harbor_keycloak_oidc_admin_group
    }
  ))

  prometheus_url   = "https://${local.prometheus_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"
  alertmanager_url = "https://${local.alertmanager_oauth2_proxy_values_parsed.oauth2-proxy.ingress.hosts.0}"
  grafana_url      = local.kube_prometheus_stack_values_parsed.kube-prometheus-stack.grafana["grafana.ini"].server.root_url
  backend_url      = "https://${local.backend_values_parsed.ingress.host}"
}