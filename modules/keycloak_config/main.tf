# Master realm

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

  role_ids = [data.keycloak_role.admin.id]
}

resource "keycloak_oidc_google_identity_provider" "master" {
  realm         = data.keycloak_realm.master.id
  client_id     = var.google_identity_provider_client_id
  client_secret = var.google_identity_provider_client_secret

  request_refresh_token = true
  disable_user_info     = true
  sync_mode             = "LEGACY"

  count = coalesce(var.google_identity_provider_client_id, "no_google_identity_provider") == "no_google_identity_provider" ? 0 : 1
}

# Infra realm

module "keycloak_realm" {
  source     = "../keycloak_realm"
  realm_name = var.infra_realm_name
}

resource "keycloak_oidc_google_identity_provider" "infra" {
  realm         = module.keycloak_realm.realm_id
  client_id     = var.google_identity_provider_client_id
  client_secret = var.google_identity_provider_client_secret

  request_refresh_token = "false"
  default_scopes        = ["openid", "email"]
  trust_email           = true
  sync_mode             = "LEGACY"

  count = coalesce(var.google_identity_provider_client_id, "no_google_identity_provider") == "no_google_identity_provider" ? 0 : 1
}

# Client scope

resource "keycloak_openid_client_scope" "groups_client_scope" {
  realm_id               = module.keycloak_realm.realm_id
  name                   = "groups"
  description            = "When requested, this scope will map a user's group memberships to a claim"
  include_in_token_scope = true
}

# Group membership mapper

resource "keycloak_openid_group_membership_protocol_mapper" "group_membership_mapper" {
  realm_id        = module.keycloak_realm.realm_id
  client_scope_id = keycloak_openid_client_scope.groups_client_scope.id
  name            = "groups"

  claim_name = "groups"
  full_path  = false
}
