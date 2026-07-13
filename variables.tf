variable "postgresql_flexible_servers" {
  description = <<EOT
Map of postgresql_flexible_servers, attributes below
Required:
    - location
    - name
    - resource_group_name
Optional:
    - administrator_login
    - administrator_password
    - administrator_password_key_vault_id (alternative to administrator_password - read from Key Vault instead)
    - administrator_password_key_vault_secret_name (alternative to administrator_password - read from Key Vault instead)
    - administrator_password_wo
    - administrator_password_wo_version
    - auto_grow_enabled
    - backup_retention_days
    - create_mode
    - delegated_subnet_id
    - geo_redundant_backup_enabled
    - point_in_time_restore_time_in_utc
    - private_dns_zone_id
    - public_network_access_enabled
    - replication_role
    - sku_name
    - source_server_id
    - storage_mb
    - storage_tier
    - tags
    - version
    - zone
    - authentication (block):
        - active_directory_auth_enabled (optional)
        - password_auth_enabled (optional)
        - tenant_id (optional)
    - cluster (block):
        - default_database_name (optional)
        - size (required)
    - customer_managed_key (block):
        - geo_backup_key_vault_key_id (optional)
        - geo_backup_user_assigned_identity_id (optional)
        - key_vault_key_id (required)
        - primary_user_assigned_identity_id (optional)
    - high_availability (block):
        - mode (required)
        - standby_availability_zone (optional)
    - identity (block):
        - identity_ids (optional)
        - type (required)
    - maintenance_window (block):
        - day_of_week (optional)
        - start_hour (optional)
        - start_minute (optional)
EOT

  type = map(object({
    location                                     = string
    name                                         = string
    resource_group_name                          = string
    tags                                         = optional(map(string))
    storage_tier                                 = optional(string)
    storage_mb                                   = optional(number)
    source_server_id                             = optional(string)
    sku_name                                     = optional(string)
    replication_role                             = optional(string)
    public_network_access_enabled                = optional(bool)
    private_dns_zone_id                          = optional(string)
    point_in_time_restore_time_in_utc            = optional(string)
    geo_redundant_backup_enabled                 = optional(bool)
    delegated_subnet_id                          = optional(string)
    create_mode                                  = optional(string)
    backup_retention_days                        = optional(number)
    auto_grow_enabled                            = optional(bool)
    administrator_password_wo_version            = optional(number)
    administrator_password_wo                    = optional(string)
    administrator_password                       = optional(string)
    administrator_password_key_vault_id          = optional(string)
    administrator_password_key_vault_secret_name = optional(string)
    administrator_login                          = optional(string)
    version                                      = optional(string)
    zone                                         = optional(string)
    authentication = optional(object({
      active_directory_auth_enabled = optional(bool)
      password_auth_enabled         = optional(bool)
      tenant_id                     = optional(string)
    }))
    cluster = optional(object({
      default_database_name = optional(string)
      size                  = number
    }))
    customer_managed_key = optional(object({
      geo_backup_key_vault_key_id          = optional(string)
      geo_backup_user_assigned_identity_id = optional(string)
      key_vault_key_id                     = string
      primary_user_assigned_identity_id    = optional(string)
    }))
    high_availability = optional(object({
      mode                      = string
      standby_availability_zone = optional(string)
    }))
    identity = optional(object({
      identity_ids = optional(set(string))
      type         = string
    }))
    maintenance_window = optional(object({
      day_of_week  = optional(number)
      start_hour   = optional(number)
      start_minute = optional(number)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        length(v.name) >= 1
      )
    ])
    error_message = "[from validate.FlexibleServerName: invalid when len(value) < 1]"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        length(v.name) <= 63
      )
    ])
    error_message = "[from validate.FlexibleServerName: invalid when len(value) > 63]"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        length(v.resource_group_name) <= 90
      )
    ])
    error_message = "[from resourcegroups.ValidateName: invalid when len(value) > 90]"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        !endswith(v.resource_group_name, ".")
      )
    ])
    error_message = "[from resourcegroups.ValidateName: must not end with \".\"]"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        length(v.resource_group_name) != 0
      )
    ])
    error_message = "[from resourcegroups.ValidateName: invalid when len(value) == 0]"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        v.administrator_password == null || (length(v.administrator_password) > 0)
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        v.administrator_password_wo == null || (length(v.administrator_password_wo) > 0)
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        v.authentication == null || (v.authentication.tenant_id == null || (can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", v.authentication.tenant_id))))
      )
    ])
    error_message = "must be a valid UUID"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        v.storage_mb == null || (contains([32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4193280, 4194304, 8388608, 16777216, 33553408], v.storage_mb))
      )
    ])
    error_message = "must be one of: 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4193280, 4194304, 8388608, 16777216, 33553408"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        v.zone == null || (length(v.zone) > 0)
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        v.maintenance_window == null || (v.maintenance_window.day_of_week == null || (v.maintenance_window.day_of_week >= 0 && v.maintenance_window.day_of_week <= 6))
      )
    ])
    error_message = "must be between 0 and 6"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        v.maintenance_window == null || (v.maintenance_window.start_hour == null || (v.maintenance_window.start_hour >= 0 && v.maintenance_window.start_hour <= 23))
      )
    ])
    error_message = "must be between 0 and 23"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        v.maintenance_window == null || (v.maintenance_window.start_minute == null || (v.maintenance_window.start_minute >= 0 && v.maintenance_window.start_minute <= 59))
      )
    ])
    error_message = "must be between 0 and 59"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        v.backup_retention_days == null || (v.backup_retention_days >= 7 && v.backup_retention_days <= 35)
      )
    ])
    error_message = "must be between 7 and 35"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        v.high_availability == null || (v.high_availability.standby_availability_zone == null || (length(v.high_availability.standby_availability_zone) > 0))
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        v.cluster == null || (v.cluster.size >= 1 && v.cluster.size <= 20)
      )
    ])
    error_message = "must be between 1 and 20"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        v.cluster == null || (v.cluster.default_database_name == null || (length(v.cluster.default_database_name) > 0))
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.postgresql_flexible_servers : (
        v.tags == null || (length(v.tags) <= 50)
      )
    ])
    error_message = "[from tags.Validate: invalid when len(value) > 50]"
  }
  # Note: 33 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

