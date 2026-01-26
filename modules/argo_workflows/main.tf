resource "kubernetes_namespace" "argo" {
  metadata {
    name = var.namespace
  }
  # Only create the namespace if it doesn't already exist
  count = var.namespace == "kube-system" ? 0 : 1
}

# Create all workflow namespaces except the main Argo install namespace.
# This avoids the edge case where the install namespace is also listed as a workflow namespace.
resource "kubernetes_namespace" "workflows" {
  for_each = length(var.workflows_namespaces) > 0 ? setsubtract(var.workflows_namespaces, [var.namespace]) : []
  metadata {
    name = each.value
  }
}

# Given Argo Workflows values.yaml file,
# the SSO server clientId and clientSecret
# are potentially stored in two different secrets
# we use Terraform's "count" with conditional check
# to account for each case

resource "kubernetes_secret" "oidc_client_id_and_secret" {
  metadata {
    name      = var.sso_server_client_id_name
    namespace = var.namespace
  }

  data = {
    "${var.sso_server_client_id_key}"     = var.keycloak_client_id
    "${var.sso_server_client_secret_key}" = var.keycloak_client_secret
  }
  count = var.sso_server_client_secret_name == var.sso_server_client_id_name ? 1 : 0
}

resource "kubernetes_secret" "oidc_client_id" {
  metadata {
    name      = var.sso_server_client_id_name
    namespace = var.namespace
  }

  data = {
    "${var.sso_server_client_id_key}" = var.keycloak_client_id
  }
  count = var.sso_server_client_secret_name != var.sso_server_client_id_name ? 1 : 0
}

resource "kubernetes_secret" "oidc_client_secret" {
  metadata {
    name      = var.sso_server_client_secret_name
    namespace = var.namespace
  }

  data = {
    "${var.sso_server_client_secret_key}" = var.keycloak_client_secret
  }
  count = var.sso_server_client_secret_name != var.sso_server_client_id_name ? 1 : 0
}
