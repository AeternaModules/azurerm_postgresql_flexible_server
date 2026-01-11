resource "azurerm_postgresql_flexible_server" "postgresql_flexible_servers" {
  for_each = var.postgresql_flexible_servers

  location                          = each.value.location
  name                              = each.value.name
  resource_group_name               = each.value.resource_group_name
  tags                              = each.value.tags
  storage_tier                      = each.value.storage_tier
  storage_mb                        = each.value.storage_mb
  source_server_id                  = each.value.source_server_id
  sku_name                          = each.value.sku_name
  replication_role                  = each.value.replication_role
  public_network_access_enabled     = each.value.public_network_access_enabled
  private_dns_zone_id               = each.value.private_dns_zone_id
  point_in_time_restore_time_in_utc = each.value.point_in_time_restore_time_in_utc
  geo_redundant_backup_enabled      = each.value.geo_redundant_backup_enabled
  delegated_subnet_id               = each.value.delegated_subnet_id
  create_mode                       = each.value.create_mode
  backup_retention_days             = each.value.backup_retention_days
  auto_grow_enabled                 = each.value.auto_grow_enabled
  administrator_password_wo_version = each.value.administrator_password_wo_version
  administrator_password_wo         = each.value.administrator_password_wo
  administrator_password            = each.value.administrator_password
  administrator_login               = each.value.administrator_login
  version                           = each.value.version
  zone                              = each.value.zone

  dynamic "authentication" {
    for_each = each.value.authentication != null ? [each.value.authentication] : []
    content {
      active_directory_auth_enabled = authentication.value.active_directory_auth_enabled
      password_auth_enabled         = authentication.value.password_auth_enabled
      tenant_id                     = authentication.value.tenant_id
    }
  }

  dynamic "customer_managed_key" {
    for_each = each.value.customer_managed_key != null ? [each.value.customer_managed_key] : []
    content {
      geo_backup_key_vault_key_id          = customer_managed_key.value.geo_backup_key_vault_key_id
      geo_backup_user_assigned_identity_id = customer_managed_key.value.geo_backup_user_assigned_identity_id
      key_vault_key_id                     = customer_managed_key.value.key_vault_key_id
      primary_user_assigned_identity_id    = customer_managed_key.value.primary_user_assigned_identity_id
    }
  }

  dynamic "high_availability" {
    for_each = each.value.high_availability != null ? [each.value.high_availability] : []
    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = high_availability.value.standby_availability_zone
    }
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      identity_ids = identity.value.identity_ids
      type         = identity.value.type
    }
  }

  dynamic "maintenance_window" {
    for_each = each.value.maintenance_window != null ? [each.value.maintenance_window] : []
    content {
      day_of_week  = maintenance_window.value.day_of_week
      start_hour   = maintenance_window.value.start_hour
      start_minute = maintenance_window.value.start_minute
    }
  }
}

