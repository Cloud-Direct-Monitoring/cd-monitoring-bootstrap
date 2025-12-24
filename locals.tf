locals {
  github_actions_variables = merge(
    {
      "TENANT_ID"                     = var.customer_tenant_id,
      "SUBSCRIPTION_ID"               = var.customer_subscription_id,
      "RESOURCE_GROUP_NAME"           = azurerm_resource_group.rg.name,
      "LOCATION"                      = var.location,
      "WORKSPACE_SUBSCRIPTION_ID"     = split("/", var.workspace_id)[2],
      "WORKSPACE_RESOURCE_GROUP_NAME" = split("/", var.workspace_id)[4],
      "WORKSPACE_NAME"                = split("/", var.workspace_id)[8],
      "WORKSPACE_ID"                  = var.workspace_id,
      "MASTER_TEMPLATES_GIT_ORG"      = "Cloud-Direct-Monitoring",
      "MASTER_TEMPLATES_GIT_REPO"     = "cd-monitoring-azure-templates",
      "MASTER_TEMPLATES_GIT_BRANCH"   = "main"
    },
    var.deploy_storage ? {
      "STORAGE_ACCOUNT_NAME" = azurerm_storage_account.state[0].name
    } : {}
  )

  uniq = substr(sha1(azurerm_resource_group.rg.id), 0, 8)

  storage_account_name = var.storage_account_name != null ? var.storage_account_name : "cdmonitoring${local.uniq}"

  region_map = {
    "UK South" = "uksouth"
    "UK West"  = "ukwest"
  }

  region_short = var.region_short != null ? var.region_short : try(local.region_map[var.location], replace(lower(var.location), " ", ""))

  # normalize selector
  target = lower(var.monitoring_selection)

  # When target == "azure", no middle segment. Otherwise "avd" or "data".
  target_segment = local.target == "azure" ? "" : "${local.target}-"

  # Resource Group name
  resource_group_name = var.resource_group_name != null ? var.resource_group_name :"rg-cdmonitoring-${local.target_segment}${var.environment}-${local.region_short}-001"

  # Core MI
  mi_core_name = "id-cdmonitoring-${local.target_segment}${var.environment}-${local.region_short}-001"

  # ARG MI
  mi_arg_name = "id-cdmonitoring-${local.target_segment}arg-${var.environment}-${local.region_short}-001"

  # Policy MI
  mi_policy_name = "id-cdmonitoring-${local.target_segment}policy-${var.environment}-${local.region_short}-001"

  # VM MI
  mi_vm_name = "id-cdmonitoring-${local.target_segment}vm-${var.environment}-${local.region_short}-001"

  # === Bicep params switching (only for azure/avd) ===
  create_bicep_params = local.target == "data" ? false : true

  bicep_file_map = {
    azure = "parameters/coreMonitoringComponents.bicepparam"
    avd   = "parameters/avdMonitoringComponents.bicepparam"
  }

  bicep_tpl_map = {
    azure = "${path.module}/templates/coreMonitoringComponents.bicepparam.tftpl"
    avd   = "${path.module}/templates/avdMonitoringComponents.bicepparam.tftpl"
  }
}
