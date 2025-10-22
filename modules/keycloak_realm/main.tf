resource "keycloak_realm" "new_realm" {
  realm                       = var.realm_name
  default_signature_algorithm = "RS256"
  revoke_refresh_token        = true
  refresh_token_max_reuse     = 0

  registration_allowed     = false
  login_with_email_allowed = true
  password_policy          = "length(8) and specialChars(1) and upperCase(1) and lowerCase(1) and digits(1) and notUsername and notEmail and notContainsUsername"
}

# User profile

resource "keycloak_realm_user_profile" "userprofile" {
  realm_id = keycloak_realm.new_realm.id

  attribute {
    name         = "username"
    display_name = "$${username}"

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "length"
      config = {
        min = 3
        max = 8
      }
    }

    validator {
      name = "pattern"
      config = {
        pattern       = "^(?!(root|bin|daemon|adm|lp|sync|shutdown|halt|mail|news|uucp|operator|games|gopher|nobody|www-data|proxy|backup|sys|man|postfix|sshd|ftp|mysql|postgres|dnsmasq|ntp|messagebus|haldaemon|rpc|avahi|saned|usbmux|kernoops|admin|sysadmin|user|guest|test|administrator|rootuser|default|system|superuser)$)[a-z_][a-z0-9_-]*$"
        error-message = "Invalid username"
      }
    }
  }

  attribute {
    name         = "email"
    display_name = "$${email}"

    required_for_roles = ["user"]

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name   = "email"
      config = {}
    }

    validator {
      name = "length"
      config = {
        max = 255
      }
    }
  }

  attribute {
    name         = "firstName"
    display_name = "$${firstName}"

    required_for_roles = ["user"]

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "length"
      config = {
        max = 255
      }
    }

    validator {
      name = "person-name-prohibited-characters"
    }
  }

  attribute {
    name         = "lastName"
    display_name = "$${lastName}"

    required_for_roles = ["user"]

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "length"
      config = {
        max = 255
      }
    }

    validator {
      name = "person-name-prohibited-characters"
    }
  }
}
