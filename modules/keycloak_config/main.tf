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

module "keycloak_realm" {
  source = "../keycloak_realm"
  realm_name = var.infra_realm_name
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
