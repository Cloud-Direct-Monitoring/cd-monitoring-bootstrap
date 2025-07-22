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
}
