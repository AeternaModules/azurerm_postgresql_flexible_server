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
  # --- Unconfirmed validation candidates, derived from azurerm_postgresql_flexible_server's provider source ---
  # Not auto-enabled: either a bespoke provider validator we can't safely translate,
  # or a path that crosses a list-typed block (needs its own for_each wrapping).
  # Review, translate into a real validation{} block above, and delete once confirmed.
  # path: name
  #   source:    [from validate.FlexibleServerName] !ok
  # path: name
  #   condition: length(value) >= 1
  #   message:   [from validate.FlexibleServerName: invalid when len(value) < 1]
  #   source:    [from validate.FlexibleServerName: invalid when len(value) < 1]
  # path: name
  #   condition: length(value) <= 63
  #   message:   [from validate.FlexibleServerName: invalid when len(value) > 63]
  #   source:    [from validate.FlexibleServerName: invalid when len(value) > 63]
  # path: name
  #   source:    [from validate.FlexibleServerName] !regexp.MustCompile(`^[a-z0-9]([a-z0-9-]+[a-z0-9])?$`).MatchString(v)
  # path: resource_group_name
  #   condition: length(value) <= 90
  #   message:   [from resourcegroups.ValidateName: invalid when len(value) > 90]
  #   source:    [from resourcegroups.ValidateName: invalid when len(value) > 90]
  # path: resource_group_name
  #   condition: !endswith(value, ".")
  #   message:   [from resourcegroups.ValidateName: must not end with "."]
  #   source:    [from resourcegroups.ValidateName: must not end with "."]
  # path: resource_group_name
  #   condition: length(value) != 0
  #   message:   [from resourcegroups.ValidateName: invalid when len(value) == 0]
  #   source:    [from resourcegroups.ValidateName: invalid when len(value) == 0]
  # path: resource_group_name
  #   source:    [from resourcegroups.ValidateName] !matched
  # path: location
  #   source:    location.EnhancedValidate: no recognizable `if ... { errors = append(...) }` pattern - read it by hand
  # path: administrator_login
  #   source:    validation.All(...) - no translation rule yet, add one
  # path: administrator_password
  #   condition: length(value) > 0
  #   message:   must not be empty
  # path: administrator_password_wo
  #   condition: length(value) > 0
  #   message:   must not be empty
  # path: authentication.tenant_id
  #   condition: can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", value))
  #   message:   must be a valid UUID
  # path: sku_name
  #   source:    [from validate.FlexibleServerSkuName] !ok
  # path: sku_name
  #   source:    [from validate.FlexibleServerSkuName] !regexp.MustCompile(`^((B_Standard_B((1|2|4|8|12|16|20)ms|2s))|(GP_Standard_D(((2|4|8|16|32|48|64)s_v3)|((2|4|8|16|32|48|64)ds_v4)|((2|4|8|16|32|48|64|96)ds_v5)|((2|4|8|16|32|48|64|96)ds_v6)|((2|4|8|16|32|48|64|96)ads_v5)|(C(2|4|8|16|32|48|64|96)ads_v5)))|(MO_Standard_E((((2|4|8|16|20|32|48|64)s)_v3)|((2|4|6|8|16|20|32|48|64)ds_v4)|((2|4|8|16|20|32|48|64|96)ds_v5)|((2|4|8|16|32|48|64|96)ds_v6)|((2|4|8|16|32|48|64|96)ads_v5)|(C(2|4|8|16|20|32|48|64|96)(ads|as)_v5))))$`).MatchString(v)
  # path: storage_mb
  #   source:    validation.IntInSlice(...) - no translation rule yet, add one
  # path: storage_tier
  #   source:    validation.StringInSlice value list is not a literal []string - likely a generated PossibleValuesFor*() helper; resolve separately
  # path: version
  #   source:    validation.StringInSlice value list is not a literal []string - likely a generated PossibleValuesFor*() helper; resolve separately
  # path: zone
  #   condition: length(value) > 0
  #   message:   must not be empty
  # path: create_mode
  #   source:    validation.StringInSlice value list is not a literal []string - likely a generated PossibleValuesFor*() helper; resolve separately
  # path: delegated_subnet_id
  #   source:    [from commonids.ValidateSubnetID] !ok
  # path: delegated_subnet_id
  #   source:    [from commonids.ValidateSubnetID] err != nil
  # path: private_dns_zone_id
  #   source:    [from privatezones.ValidatePrivateDnsZoneID] !ok
  # path: private_dns_zone_id
  #   source:    [from privatezones.ValidatePrivateDnsZoneID] err != nil
  # path: point_in_time_restore_time_in_utc
  #   source:    validation.IsRFC3339Time(...) - no translation rule yet, add one
  # path: source_server_id
  #   source:    [from servers.ValidateFlexibleServerID] !ok
  # path: source_server_id
  #   source:    [from servers.ValidateFlexibleServerID] err != nil
  # path: maintenance_window.day_of_week
  #   condition: value >= 0 && value <= 6
  #   message:   must be between 0 and 6
  # path: maintenance_window.start_hour
  #   condition: value >= 0 && value <= 23
  #   message:   must be between 0 and 23
  # path: maintenance_window.start_minute
  #   condition: value >= 0 && value <= 59
  #   message:   must be between 0 and 59
  # path: backup_retention_days
  #   condition: value >= 7 && value <= 35
  #   message:   must be between 7 and 35
  # path: high_availability.mode
  #   source:    validation.StringInSlice value list is not a literal []string - likely a generated PossibleValuesFor*() helper; resolve separately
  # path: high_availability.standby_availability_zone
  #   condition: length(value) > 0
  #   message:   must not be empty
  # path: replication_role
  #   source:    validation.StringInSlice value list is not a literal []string - likely a generated PossibleValuesFor*() helper; resolve separately
  # path: identity.type
  #   source:    validation.StringInSlice value list is not a literal []string - likely a generated PossibleValuesFor*() helper; resolve separately
  # path: identity.identity_ids[*]
  #   source:    [from commonids.ValidateUserAssignedIdentityID] !ok
  # path: identity.identity_ids[*]
  #   source:    [from commonids.ValidateUserAssignedIdentityID] err != nil
  # path: customer_managed_key.key_vault_key_id
  #   source:    [from keyvault.ValidateNestedItemID] !ok
  # path: customer_managed_key.key_vault_key_id
  #   source:    [from keyvault.ValidateNestedItemID] err != nil
  # path: customer_managed_key.primary_user_assigned_identity_id
  #   source:    [from commonids.ValidateUserAssignedIdentityID] !ok
  # path: customer_managed_key.primary_user_assigned_identity_id
  #   source:    [from commonids.ValidateUserAssignedIdentityID] err != nil
  # path: customer_managed_key.geo_backup_key_vault_key_id
  #   source:    [from keyvault.ValidateNestedItemID] !ok
  # path: customer_managed_key.geo_backup_key_vault_key_id
  #   source:    [from keyvault.ValidateNestedItemID] err != nil
  # path: customer_managed_key.geo_backup_user_assigned_identity_id
  #   source:    [from commonids.ValidateUserAssignedIdentityID] !ok
  # path: customer_managed_key.geo_backup_user_assigned_identity_id
  #   source:    [from commonids.ValidateUserAssignedIdentityID] err != nil
  # path: cluster.size
  #   condition: value >= 1 && value <= 20
  #   message:   must be between 1 and 20
  # path: cluster.default_database_name
  #   condition: length(value) > 0
  #   message:   must not be empty
  # path: tags
  #   condition: length(value) <= 50
  #   message:   [from tags.Validate: invalid when len(value) > 50]
  #   source:    [from tags.Validate: invalid when len(value) > 50]
  # path: tags
  #   condition: length(value) <= 512
  #   message:   [from tags.Validate: invalid when len(value) > 512]
  #   source:    [from tags.Validate: invalid when len(value) > 512]
  # path: tags
  #   source:    [from tags.Validate] err != nil
  # path: tags
  #   condition: length(value) <= 256
  #   message:   [from tags.Validate: invalid when len(value) > 256]
  #   source:    [from tags.Validate: invalid when len(value) > 256]
}

