data "keycloak_realm" "master" {
  realm = "master"
}

resource "keycloak_group" "chorus_admin" {
  realm_id = data.keycloak_realm.master.id
  name     = "CHORUS-admin"
}

data "keycloak_role" "admin" {
  realm_id = data.keycloak_realm.master.id
  name     = "admin"
}

resource "keycloak_group_roles" "chorus_admins_group_roles" {
  realm_id = data.keycloak_realm.master.id
  group_id = keycloak_group.chorus_admin.id

  role_ids = [
    data.keycloak_role.admin.id
  ]
}

resource "keycloak_realm" "build" {
  realm                       = var.realm_name
  organizations_enabled       = true
  default_signature_algorithm = "RS256"
  revoke_refresh_token        = true
  refresh_token_max_reuse     = 0
}

resource "keycloak_openid_client" "openid_client" {
  for_each = var.clients_config

  realm_id      = keycloak_realm.build.id
  client_id     = each.key
  client_secret = each.value.client_secret
  enabled       = true
  access_type   = "CONFIDENTIAL"

  root_url            = each.value.root_url
  base_url            = each.value.base_url
  admin_url           = each.value.admin_url
  web_origins         = each.value.web_origins
  valid_redirect_uris = each.value.valid_redirect_uris

  standard_flow_enabled        = true
  implicit_flow_enabled        = true
  direct_access_grants_enabled = true
  frontchannel_logout_enabled  = true
}

resource "keycloak_group" "openid_client_group" {
  for_each = { for k, v in var.clients_config : k => v if can(v.client_group) && v.client_group != "" && v.client_group != null }

  realm_id = keycloak_realm.build.id
  name     = each.value.client_group
}

# Special case for Grafana
data "keycloak_group" "grafana_group" {
  realm_id = keycloak_realm.build.id
  name     = "Grafana"

  depends_on = [keycloak_group.openid_client_group]
}

resource "keycloak_group" "grafana_editors_group" {
  realm_id  = keycloak_realm.build.id
  parent_id = data.keycloak_group.grafana_group.id
  name      = "Editors"
}

resource "keycloak_group" "grafana_admins_group" {
  realm_id  = keycloak_realm.build.id
  parent_id = keycloak_group.grafana_editors_group.id
  name      = "Administrators"
}

resource "keycloak_role" "grafana_admin" {
  realm_id = keycloak_realm.build.id
  name     = "grafana-admin"
}

resource "keycloak_role" "grafana_editor" {
  realm_id = keycloak_realm.build.id
  name     = "grafana-editor"
}

resource "keycloak_group_roles" "grafana_editors_group_roles" {
  realm_id = keycloak_realm.build.id
  group_id = keycloak_group.grafana_editors_group.id

  role_ids = [
    keycloak_role.grafana_editor.id
  ]
}

resource "keycloak_group_roles" "grafana_admins_group_roles" {
  realm_id = keycloak_realm.build.id
  group_id = keycloak_group.grafana_admins_group.id

  role_ids = [
    keycloak_role.grafana_admin.id
  ]
}

resource "keycloak_openid_client_scope" "openid_client_scope" {
  realm_id               = keycloak_realm.build.id
  name                   = "groups"
  description            = "When requested, this scope will map a user's group memberships to a claim"
  include_in_token_scope = true
}

resource "keycloak_openid_client_optional_scopes" "client_optional_scopes" {
  for_each = keycloak_openid_client.openid_client

  realm_id  = keycloak_realm.build.id
  client_id = each.value.id

  optional_scopes = [
    "offline_access",
    "groups"
  ]
}