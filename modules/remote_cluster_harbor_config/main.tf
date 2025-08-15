# Registries

resource "harbor_registry" "docker_hub" {
  provider_name = "docker-hub"
  name          = "Docker Hub"
  endpoint_url  = "https://hub.docker.com"
}

# Projects

resource "harbor_project" "projects" {
  for_each = toset(["apps", "cache", "charts", "chorus", "services"])

  name                   = each.key
  vulnerability_scanning = "false"
  force_destroy          = true
}

# Proxy cache projects

resource "harbor_project" "proxy_cache" {
  name                   = "docker_proxy"
  registry_id            = harbor_registry.docker_hub.registry_id
  vulnerability_scanning = "false"
  force_destroy          = true
}

# Cluster robot account

resource "random_password" "cluster_robot_password" {
  length      = 32
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "harbor_robot_account" "cluster" {
  name        = var.cluster_robot_username
  description = "Used as registry credentials for this cluster"
  level       = "system"
  secret      = random_password.cluster_robot_password.result
  permissions {
    access {
      action   = "list"
      resource = "project"
    }
    access {
      action   = "list"
      resource = "registry"
    }
    access {
      action   = "read"
      resource = "registry"
    }
    kind      = "system"
    namespace = "/"
  }
  permissions {
    access {
      action   = "list"
      resource = "artifact"
    }
    access {
      action   = "read"
      resource = "artifact"
    }
    access {
      action   = "list"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "read"
      resource = "repository"
    }
    access {
      action   = "list"
      resource = "tag"
    }
    kind      = "project"
    namespace = "apps"
  }
  permissions {
    access {
      action   = "list"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "read"
      resource = "repository"
    }
    kind      = "project"
    namespace = "chorus"
  }
  permissions {
    access {
      action   = "list"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "read"
      resource = "repository"
    }
    kind      = "project"
    namespace = "services"
  }
  permissions {
    access {
      action   = "list"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "read"
      resource = "repository"
    }
    kind      = "project"
    namespace = "docker_proxy"
  }
  depends_on = [
    harbor_project.projects,
    harbor_project.proxy_cache
  ]
}


# Chorus-build robot account

resource "random_password" "build_robot_password" {
  length      = 32
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "harbor_robot_account" "build" {
  name        = var.build_robot_username
  description = "Replication from Harbor build"
  level       = "system"
  secret      = random_password.cluster_robot_password.result
  permissions {
    access {
      action   = "list"
      resource = "audit_log"
    }
    access {
      action   = "create"
      resource = "garbage_collection"
    }
    access {
      action   = "read"
      resource = "garbage_collection"
    }
    access {
      action   = "stop"
      resource = "garbage_collection"
    }
    access {
      action   = "update"
      resource = "garbage_collection"
    }
    access {
      action   = "read"
      resource = "job_service_monitor"
    }
    access {
      action   = "create"
      resource = "label"
    }
    access {
      action   = "delete"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "label"
    }
    access {
      action   = "read"
      resource = "label"
    }
    access {
      action   = "update"
      resource = "label"
    }
    access {
      action   = "create"
      resource = "preheat_instance"
    }
    access {
      action   = "delete"
      resource = "preheat_instance"
    }
    access {
      action   = "list"
      resource = "preheat_instance"
    }
    access {
      action   = "read"
      resource = "preheat_instance"
    }
    access {
      action   = "update"
      resource = "preheat_instance"
    }
    access {
      action   = "create"
      resource = "project"
    }
    access {
      action   = "list"
      resource = "project"
    }
    access {
      action   = "read"
      resource = "project"
    }
    access {
      action   = "update"
      resource = "project"
    }
    access {
      action   = "create"
      resource = "purge_audit"
    }
    access {
      action   = "read"
      resource = "purge_audit"
    }
    access {
      action   = "stop"
      resource = "purge_audit"
    }
    access {
      action   = "update"
      resource = "purge_audit"
    }
    access {
      action   = "list"
      resource = "quota"
    }
    access {
      action   = "update"
      resource = "quota"
    }
    access {
      action   = "create"
      resource = "registry"
    }
    access {
      action   = "delete"
      resource = "registry"
    }
    access {
      action   = "list"
      resource = "registry"
    }
    access {
      action   = "read"
      resource = "registry"
    }
    access {
      action   = "create"
      resource = "replication"
    }
    access {
      action   = "list"
      resource = "replication"
    }
    access {
      action   = "list"
      resource = "replication_adapter"
    }
    access {
      action   = "create"
      resource = "replication_policy"
    }
    access {
      action   = "delete"
      resource = "replication_policy"
    }
    access {
      action   = "list"
      resource = "replication_policy"
    }
    access {
      action   = "update"
      resource = "replication_policy"
    }
    access {
      action   = "create"
      resource = "scan_all"
    }
    access {
      action   = "list"
      resource = "scan_all"
    }
    access {
      action   = "stop"
      resource = "scan_all"
    }
    access {
      action   = "update"
      resource = "scan_all"
    }
    access {
      action   = "create"
      resource = "scanner"
    }
    access {
      action   = "update"
      resource = "scanner"
    }
    access {
      action   = "read"
      resource = "security_hub"
    }
    access {
      action   = "list"
      resource = "system_volumes"
    }
    kind      = "system"
    namespace = "/"
  }

  permissions {
    access {
      action   = "list"
      resource = "accessory"
    }
    access {
      action   = "create"
      resource = "artifact"
    }
    access {
      action   = "list"
      resource = "artifact"
    }
    access {
      action   = "read"
      resource = "artifact"
    }
    access {
      action   = "create"
      resource = "artifact_addition"
    }
    access {
      action   = "read"
      resource = "artifact_addition"
    }
    access {
      action   = "create"
      resource = "artifact_label"
    }
    access {
      action   = "delete"
      resource = "artifact_label"
    }
    access {
      action   = "create"
      resource = "immutable_tag"
    }
    access {
      action   = "list"
      resource = "immutable_tag"
    }
    access {
      action   = "update"
      resource = "immutable_tag"
    }
    access {
      action   = "create"
      resource = "label"
    }
    access {
      action   = "delete"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "label"
    }
    access {
      action   = "read"
      resource = "label"
    }
    access {
      action   = "update"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "log"
    }
    access {
      action   = "create"
      resource = "project_metadata"
    }
    access {
      action   = "delete"
      resource = "project_metadata"
    }
    access {
      action   = "list"
      resource = "project_metadata"
    }
    access {
      action   = "read"
      resource = "project_metadata"
    }
    access {
      action   = "update"
      resource = "project_metadata"
    }
    access {
      action   = "create"
      resource = "notification_policy"
    }
    access {
      action   = "delete"
      resource = "notification_policy"
    }
    access {
      action   = "list"
      resource = "notification_policy"
    }
    access {
      action   = "read"
      resource = "notification_policy"
    }
    access {
      action   = "update"
      resource = "notification_policy"
    }
    access {
      action   = "create"
      resource = "preheat_policy"
    }
    access {
      action   = "delete"
      resource = "preheat_policy"
    }
    access {
      action   = "list"
      resource = "preheat_policy"
    }
    access {
      action   = "read"
      resource = "preheat_policy"
    }
    access {
      action   = "update"
      resource = "preheat_policy"
    }
    access {
      action   = "create"
      resource = "project"
    }
    access {
      action   = "read"
      resource = "project"
    }
    access {
      action   = "update"
      resource = "project"
    }
    access {
      action   = "list"
      resource = "quota"
    }
    access {
      action   = "update"
      resource = "quota"
    }
    access {
      action   = "delete"
      resource = "repository"
    }
    access {
      action   = "list"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "push"
      resource = "repository"
    }
    access {
      action   = "read"
      resource = "repository"
    }
    access {
      action   = "update"
      resource = "repository"
    }
    access {
      action   = "create"
      resource = "sbom"
    }
    access {
      action   = "read"
      resource = "sbom"
    }
    access {
      action   = "create"
      resource = "scan"
    }
    access {
      action   = "read"
      resource = "scan"
    }
    access {
      action   = "stop"
      resource = "scan"
    }
    access {
      action   = "create"
      resource = "scanner"
    }
    access {
      action   = "create"
      resource = "tag"
    }
    access {
      action   = "delete"
      resource = "tag"
    }
    access {
      action   = "list"
      resource = "tag"
    }
    access {
      action   = "update"
      resource = "tag"
    }
    access {
      action   = "create"
      resource = "tag_retention"
    }
    access {
      action   = "list"
      resource = "tag_retention"
    }
    access {
      action   = "update"
      resource = "tag_retention"
    }
    kind      = "project"
    namespace = "chorus"
  }

  permissions {
    access {
      action   = "list"
      resource = "accessory"
    }
    access {
      action   = "create"
      resource = "artifact"
    }
    access {
      action   = "list"
      resource = "artifact"
    }
    access {
      action   = "read"
      resource = "artifact"
    }
    access {
      action   = "create"
      resource = "artifact_addition"
    }
    access {
      action   = "read"
      resource = "artifact_addition"
    }
    access {
      action   = "create"
      resource = "artifact_label"
    }
    access {
      action   = "delete"
      resource = "artifact_label"
    }
    access {
      action   = "create"
      resource = "immutable_tag"
    }
    access {
      action   = "list"
      resource = "immutable_tag"
    }
    access {
      action   = "update"
      resource = "immutable_tag"
    }
    access {
      action   = "create"
      resource = "label"
    }
    access {
      action   = "delete"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "label"
    }
    access {
      action   = "read"
      resource = "label"
    }
    access {
      action   = "update"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "log"
    }
    access {
      action   = "create"
      resource = "project_metadata"
    }
    access {
      action   = "delete"
      resource = "project_metadata"
    }
    access {
      action   = "list"
      resource = "project_metadata"
    }
    access {
      action   = "read"
      resource = "project_metadata"
    }
    access {
      action   = "update"
      resource = "project_metadata"
    }
    access {
      action   = "create"
      resource = "notification_policy"
    }
    access {
      action   = "delete"
      resource = "notification_policy"
    }
    access {
      action   = "list"
      resource = "notification_policy"
    }
    access {
      action   = "read"
      resource = "notification_policy"
    }
    access {
      action   = "update"
      resource = "notification_policy"
    }
    access {
      action   = "create"
      resource = "preheat_policy"
    }
    access {
      action   = "delete"
      resource = "preheat_policy"
    }
    access {
      action   = "list"
      resource = "preheat_policy"
    }
    access {
      action   = "read"
      resource = "preheat_policy"
    }
    access {
      action   = "update"
      resource = "preheat_policy"
    }
    access {
      action   = "create"
      resource = "project"
    }
    access {
      action   = "read"
      resource = "project"
    }
    access {
      action   = "update"
      resource = "project"
    }
    access {
      action   = "list"
      resource = "quota"
    }
    access {
      action   = "update"
      resource = "quota"
    }
    access {
      action   = "delete"
      resource = "repository"
    }
    access {
      action   = "list"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "push"
      resource = "repository"
    }
    access {
      action   = "read"
      resource = "repository"
    }
    access {
      action   = "update"
      resource = "repository"
    }
    access {
      action   = "create"
      resource = "sbom"
    }
    access {
      action   = "read"
      resource = "sbom"
    }
    access {
      action   = "create"
      resource = "scan"
    }
    access {
      action   = "read"
      resource = "scan"
    }
    access {
      action   = "stop"
      resource = "scan"
    }
    access {
      action   = "create"
      resource = "scanner"
    }
    access {
      action   = "create"
      resource = "tag"
    }
    access {
      action   = "delete"
      resource = "tag"
    }
    access {
      action   = "list"
      resource = "tag"
    }
    access {
      action   = "update"
      resource = "tag"
    }
    access {
      action   = "create"
      resource = "tag_retention"
    }
    access {
      action   = "list"
      resource = "tag_retention"
    }
    access {
      action   = "update"
      resource = "tag_retention"
    }
    kind      = "project"
    namespace = "services"
  }

  permissions {
    access {
      action   = "list"
      resource = "accessory"
    }
    access {
      action   = "create"
      resource = "artifact"
    }
    access {
      action   = "list"
      resource = "artifact"
    }
    access {
      action   = "read"
      resource = "artifact"
    }
    access {
      action   = "create"
      resource = "artifact_addition"
    }
    access {
      action   = "read"
      resource = "artifact_addition"
    }
    access {
      action   = "create"
      resource = "artifact_label"
    }
    access {
      action   = "delete"
      resource = "artifact_label"
    }
    access {
      action   = "create"
      resource = "immutable_tag"
    }
    access {
      action   = "list"
      resource = "immutable_tag"
    }
    access {
      action   = "update"
      resource = "immutable_tag"
    }
    access {
      action   = "create"
      resource = "label"
    }
    access {
      action   = "delete"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "label"
    }
    access {
      action   = "read"
      resource = "label"
    }
    access {
      action   = "update"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "log"
    }
    access {
      action   = "create"
      resource = "project_metadata"
    }
    access {
      action   = "delete"
      resource = "project_metadata"
    }
    access {
      action   = "list"
      resource = "project_metadata"
    }
    access {
      action   = "read"
      resource = "project_metadata"
    }
    access {
      action   = "update"
      resource = "project_metadata"
    }
    access {
      action   = "create"
      resource = "notification_policy"
    }
    access {
      action   = "delete"
      resource = "notification_policy"
    }
    access {
      action   = "list"
      resource = "notification_policy"
    }
    access {
      action   = "read"
      resource = "notification_policy"
    }
    access {
      action   = "update"
      resource = "notification_policy"
    }
    access {
      action   = "create"
      resource = "preheat_policy"
    }
    access {
      action   = "delete"
      resource = "preheat_policy"
    }
    access {
      action   = "list"
      resource = "preheat_policy"
    }
    access {
      action   = "read"
      resource = "preheat_policy"
    }
    access {
      action   = "update"
      resource = "preheat_policy"
    }
    access {
      action   = "create"
      resource = "project"
    }
    access {
      action   = "read"
      resource = "project"
    }
    access {
      action   = "update"
      resource = "project"
    }
    access {
      action   = "list"
      resource = "quota"
    }
    access {
      action   = "update"
      resource = "quota"
    }
    access {
      action   = "delete"
      resource = "repository"
    }
    access {
      action   = "list"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "push"
      resource = "repository"
    }
    access {
      action   = "read"
      resource = "repository"
    }
    access {
      action   = "update"
      resource = "repository"
    }
    access {
      action   = "create"
      resource = "sbom"
    }
    access {
      action   = "read"
      resource = "sbom"
    }
    access {
      action   = "create"
      resource = "scan"
    }
    access {
      action   = "read"
      resource = "scan"
    }
    access {
      action   = "stop"
      resource = "scan"
    }
    access {
      action   = "create"
      resource = "scanner"
    }
    access {
      action   = "create"
      resource = "tag"
    }
    access {
      action   = "delete"
      resource = "tag"
    }
    access {
      action   = "list"
      resource = "tag"
    }
    access {
      action   = "update"
      resource = "tag"
    }
    access {
      action   = "create"
      resource = "tag_retention"
    }
    access {
      action   = "list"
      resource = "tag_retention"
    }
    access {
      action   = "update"
      resource = "tag_retention"
    }
    kind      = "project"
    namespace = "apps"
  }

  depends_on = [
    harbor_project.projects,
    harbor_project.proxy_cache
  ]
}