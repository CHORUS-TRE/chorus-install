# Projects

resource "harbor_project" "projects" {
  for_each = toset(["apps", "chorus", "services"])

  name                   = each.key
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
  depends_on = [harbor_project.projects]
}


# Chorus-build robot account

resource "random_password" "build_robot_password" {
  length      = 32
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1

  count = var.build_robot_username == "" ? 0 : 1
}

resource "harbor_robot_account" "build" {
  name        = var.build_robot_username
  description = "Replication from Harbor build"
  level       = "system"
  secret      = random_password.cluster_robot_password.result
  permissions {
    # Audit Log
    access {
      action   = "list"
      resource = "audit-log"
    }

    # Catalog
    access {
      action   = "read"
      resource = "catalog"
    }

    # Garbage Collection
    access {
      action   = "create"
      resource = "garbage-collection"
    }
    access {
      action   = "list"
      resource = "garbage-collection"
    }
    access {
      action   = "read"
      resource = "garbage-collection"
    }
    access {
      action   = "stop"
      resource = "garbage-collection"
    }
    access {
      action   = "update"
      resource = "garbage-collection"
    }

    # Job Service Monitor
    access {
      action   = "list"
      resource = "jobservice-monitor"
    }
    access {
      action   = "stop"
      resource = "jobservice-monitor"
    }

    # Label
    access {
      action   = "create"
      resource = "label"
    }
    access {
      action   = "delete"
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

    # Preheat Instance
    access {
      action   = "create"
      resource = "preheat-instance"
    }
    access {
      action   = "delete"
      resource = "preheat-instance"
    }
    access {
      action   = "list"
      resource = "preheat-instance"
    }
    access {
      action   = "read"
      resource = "preheat-instance"
    }
    access {
      action   = "update"
      resource = "preheat-instance"
    }

    # Project
    access {
      action   = "create"
      resource = "project"
    }
    access {
      action   = "list"
      resource = "project"
    }

    # Purge Audit
    access {
      action   = "create"
      resource = "purge-audit"
    }
    access {
      action   = "list"
      resource = "purge-audit"
    }
    access {
      action   = "read"
      resource = "purge-audit"
    }
    access {
      action   = "stop"
      resource = "purge-audit"
    }
    access {
      action   = "update"
      resource = "purge-audit"
    }

    # Quota
    access {
      action   = "list"
      resource = "quota"
    }
    access {
      action   = "read"
      resource = "quota"
    }

    # Registry
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
      action   = "update"
      resource = "registry"
    }

    # Replication
    access {
      action   = "create"
      resource = "replication"
    }
    access {
      action   = "list"
      resource = "replication"
    }
    access {
      action   = "read"
      resource = "replication"
    }

    # Replication Adapter
    access {
      action   = "list"
      resource = "replication-adapter"
    }

    # Replication Policy
    access {
      action   = "create"
      resource = "replication-policy"
    }
    access {
      action   = "delete"
      resource = "replication-policy"
    }
    access {
      action   = "list"
      resource = "replication-policy"
    }
    access {
      action   = "read"
      resource = "replication-policy"
    }
    access {
      action   = "update"
      resource = "replication-policy"
    }

    # Scan All
    access {
      action   = "create"
      resource = "scan-all"
    }
    access {
      action   = "read"
      resource = "scan-all"
    }
    access {
      action   = "stop"
      resource = "scan-all"
    }
    access {
      action   = "update"
      resource = "scan-all"
    }

    # Scanner
    access {
      action   = "create"
      resource = "scanner"
    }
    access {
      action   = "delete"
      resource = "scanner"
    }
    access {
      action   = "list"
      resource = "scanner"
    }
    access {
      action   = "read"
      resource = "scanner"
    }
    access {
      action   = "update"
      resource = "scanner"
    }

    # Security Hub
    access {
      action   = "list"
      resource = "security-hub"
    }
    access {
      action   = "read"
      resource = "security-hub"
    }

    # System Volumes
    access {
      action   = "read"
      resource = "system-volumes"
    }

    kind      = "system"
    namespace = "/"
  }

  permissions {
    # Accessory
    access {
      action   = "list"
      resource = "accessory"
    }

    # Artifact
    access {
      action   = "create"
      resource = "artifact"
    }
    access {
      action   = "delete"
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

    # Artifact Addition
    access {
      action   = "read"
      resource = "artifact-addition"
    }

    # Artifact Label
    access {
      action   = "create"
      resource = "artifact-label"
    }
    access {
      action   = "delete"
      resource = "artifact-label"
    }

    # Immutable Tag
    access {
      action   = "create"
      resource = "immutable-tag"
    }
    access {
      action   = "delete"
      resource = "immutable-tag"
    }
    access {
      action   = "list"
      resource = "immutable-tag"
    }
    access {
      action   = "update"
      resource = "immutable-tag"
    }

    # Label
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

    # Log
    access {
      action   = "list"
      resource = "log"
    }

    # Project Metadata
    access {
      action   = "create"
      resource = "metadata"
    }
    access {
      action   = "delete"
      resource = "metadata"
    }
    access {
      action   = "list"
      resource = "metadata"
    }
    access {
      action   = "read"
      resource = "metadata"
    }
    access {
      action   = "update"
      resource = "metadata"
    }

    # Notification Policy
    access {
      action   = "create"
      resource = "notification-policy"
    }
    access {
      action   = "delete"
      resource = "notification-policy"
    }
    access {
      action   = "list"
      resource = "notification-policy"
    }
    access {
      action   = "read"
      resource = "notification-policy"
    }
    access {
      action   = "update"
      resource = "notification-policy"
    }

    # Preheat Policy
    access {
      action   = "create"
      resource = "preheat-policy"
    }
    access {
      action   = "delete"
      resource = "preheat-policy"
    }
    access {
      action   = "list"
      resource = "preheat-policy"
    }
    access {
      action   = "read"
      resource = "preheat-policy"
    }
    access {
      action   = "update"
      resource = "preheat-policy"
    }

    # Project
    access {
      action   = "delete"
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

    # Quota
    access {
      action   = "read"
      resource = "quota"
    }

    # Repository
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

    # SBOM
    access {
      action   = "create"
      resource = "sbom"
    }
    access {
      action   = "read"
      resource = "sbom"
    }
    access {
      action   = "stop"
      resource = "sbom"
    }

    # Scan
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

    # Scanner
    access {
      action   = "create"
      resource = "scanner"
    }
    access {
      action   = "read"
      resource = "scanner"
    }

    # Tag
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

    # Tag Retention
    access {
      action   = "create"
      resource = "tag-retention"
    }
    access {
      action   = "delete"
      resource = "tag-retention"
    }
    access {
      action   = "list"
      resource = "tag-retention"
    }
    access {
      action   = "read"
      resource = "tag-retention"
    }
    access {
      action   = "update"
      resource = "tag-retention"
    }

    kind      = "project"
    namespace = "chorus"
  }

  permissions {
    # Accessory
    access {
      action   = "list"
      resource = "accessory"
    }

    # Artifact
    access {
      action   = "create"
      resource = "artifact"
    }
    access {
      action   = "delete"
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

    # Artifact Addition
    access {
      action   = "read"
      resource = "artifact-addition"
    }

    # Artifact Label
    access {
      action   = "create"
      resource = "artifact-label"
    }
    access {
      action   = "delete"
      resource = "artifact-label"
    }

    # Immutable Tag
    access {
      action   = "create"
      resource = "immutable-tag"
    }
    access {
      action   = "delete"
      resource = "immutable-tag"
    }
    access {
      action   = "list"
      resource = "immutable-tag"
    }
    access {
      action   = "update"
      resource = "immutable-tag"
    }

    # Label
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

    # Log
    access {
      action   = "list"
      resource = "log"
    }

    # Project Metadata
    access {
      action   = "create"
      resource = "metadata"
    }
    access {
      action   = "delete"
      resource = "metadata"
    }
    access {
      action   = "list"
      resource = "metadata"
    }
    access {
      action   = "read"
      resource = "metadata"
    }
    access {
      action   = "update"
      resource = "metadata"
    }

    # Notification Policy
    access {
      action   = "create"
      resource = "notification-policy"
    }
    access {
      action   = "delete"
      resource = "notification-policy"
    }
    access {
      action   = "list"
      resource = "notification-policy"
    }
    access {
      action   = "read"
      resource = "notification-policy"
    }
    access {
      action   = "update"
      resource = "notification-policy"
    }

    # Preheat Policy
    access {
      action   = "create"
      resource = "preheat-policy"
    }
    access {
      action   = "delete"
      resource = "preheat-policy"
    }
    access {
      action   = "list"
      resource = "preheat-policy"
    }
    access {
      action   = "read"
      resource = "preheat-policy"
    }
    access {
      action   = "update"
      resource = "preheat-policy"
    }

    # Project
    access {
      action   = "delete"
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

    # Quota
    access {
      action   = "read"
      resource = "quota"
    }

    # Repository
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

    # SBOM
    access {
      action   = "create"
      resource = "sbom"
    }
    access {
      action   = "read"
      resource = "sbom"
    }
    access {
      action   = "stop"
      resource = "sbom"
    }

    # Scan
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

    # Scanner
    access {
      action   = "create"
      resource = "scanner"
    }
    access {
      action   = "read"
      resource = "scanner"
    }

    # Tag
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

    # Tag Retention
    access {
      action   = "create"
      resource = "tag-retention"
    }
    access {
      action   = "delete"
      resource = "tag-retention"
    }
    access {
      action   = "list"
      resource = "tag-retention"
    }
    access {
      action   = "read"
      resource = "tag-retention"
    }
    access {
      action   = "update"
      resource = "tag-retention"
    }

    kind      = "project"
    namespace = "services"
  }

  permissions {
    # Accessory
    access {
      action   = "list"
      resource = "accessory"
    }

    # Artifact
    access {
      action   = "create"
      resource = "artifact"
    }
    access {
      action   = "delete"
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

    # Artifact Addition
    access {
      action   = "read"
      resource = "artifact-addition"
    }

    # Artifact Label
    access {
      action   = "create"
      resource = "artifact-label"
    }
    access {
      action   = "delete"
      resource = "artifact-label"
    }

    # Immutable Tag
    access {
      action   = "create"
      resource = "immutable-tag"
    }
    access {
      action   = "delete"
      resource = "immutable-tag"
    }
    access {
      action   = "list"
      resource = "immutable-tag"
    }
    access {
      action   = "update"
      resource = "immutable-tag"
    }

    # Label
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

    # Log
    access {
      action   = "list"
      resource = "log"
    }

    # Project Metadata
    access {
      action   = "create"
      resource = "metadata"
    }
    access {
      action   = "delete"
      resource = "metadata"
    }
    access {
      action   = "list"
      resource = "metadata"
    }
    access {
      action   = "read"
      resource = "metadata"
    }
    access {
      action   = "update"
      resource = "metadata"
    }

    # Notification Policy
    access {
      action   = "create"
      resource = "notification-policy"
    }
    access {
      action   = "delete"
      resource = "notification-policy"
    }
    access {
      action   = "list"
      resource = "notification-policy"
    }
    access {
      action   = "read"
      resource = "notification-policy"
    }
    access {
      action   = "update"
      resource = "notification-policy"
    }

    # Preheat Policy
    access {
      action   = "create"
      resource = "preheat-policy"
    }
    access {
      action   = "delete"
      resource = "preheat-policy"
    }
    access {
      action   = "list"
      resource = "preheat-policy"
    }
    access {
      action   = "read"
      resource = "preheat-policy"
    }
    access {
      action   = "update"
      resource = "preheat-policy"
    }

    # Project
    access {
      action   = "delete"
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

    # Quota
    access {
      action   = "read"
      resource = "quota"
    }

    # Repository
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

    # SBOM
    access {
      action   = "create"
      resource = "sbom"
    }
    access {
      action   = "read"
      resource = "sbom"
    }
    access {
      action   = "stop"
      resource = "sbom"
    }

    # Scan
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

    # Scanner
    access {
      action   = "create"
      resource = "scanner"
    }
    access {
      action   = "read"
      resource = "scanner"
    }

    # Tag
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

    # Tag Retention
    access {
      action   = "create"
      resource = "tag-retention"
    }
    access {
      action   = "delete"
      resource = "tag-retention"
    }
    access {
      action   = "list"
      resource = "tag-retention"
    }
    access {
      action   = "read"
      resource = "tag-retention"
    }
    access {
      action   = "update"
      resource = "tag-retention"
    }

    kind      = "project"
    namespace = "apps"
  }

  count = var.build_robot_username == "" ? 0 : 1
}

# Replications

resource "harbor_registry" "pull_registry" {
  provider_name = "harbor"
  name          = var.pull_replication_registry_name
  endpoint_url  = var.pull_replication_registry_url

  count = var.pull_replication_registry_name == "" ? 0 : 1
}

resource "harbor_replication" "pull_registry" {
  name        = var.pull_replication_registry_name
  action      = "pull"
  registry_id = harbor_registry.pull_registry.registry_id
  schedule    = "0 */5 * * * *"
  filters {
    name = "{apps,chorus,services}/**"
  }

  count = var.pull_replication_registry_name == "" ? 0 : 1
}