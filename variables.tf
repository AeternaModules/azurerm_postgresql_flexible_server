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
    location                          = string
    name                              = string
    resource_group_name               = string
    tags                              = optional(map(string))
    storage_tier                      = optional(string)
    storage_mb                        = optional(number)
    source_server_id                  = optional(string)
    sku_name                          = optional(string)
    replication_role                  = optional(string)
    public_network_access_enabled     = optional(bool, true)
    private_dns_zone_id               = optional(string)
    point_in_time_restore_time_in_utc = optional(string)
    geo_redundant_backup_enabled      = optional(bool, false)
    delegated_subnet_id               = optional(string)
    create_mode                       = optional(string)
    backup_retention_days             = optional(number)
    auto_grow_enabled                 = optional(bool, false)
    administrator_password_wo_version = optional(number)
    administrator_password_wo         = optional(string)
    administrator_password            = optional(string)
    administrator_login               = optional(string)
    version                           = optional(string)
    zone                              = optional(string)
    authentication = optional(object({
      active_directory_auth_enabled = optional(bool, false)
      password_auth_enabled         = optional(bool, true)
      tenant_id                     = optional(string)
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
      day_of_week  = optional(number, 0)
      start_hour   = optional(number, 0)
      start_minute = optional(number, 0)
    }))
  }))
}

