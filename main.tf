// Resource group and storage account
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "state" {
  count               = var.deploy_storage ? 1 : 0
  name                = local.storage_account_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags

  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  access_tier              = "Cool"

  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  shared_access_key_enabled       = false
  public_network_access_enabled   = true
  default_to_oauth_authentication = true
  local_user_enabled              = false
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 90
    }
    container_delete_retention_policy {
      days = 90
    }
  }
}

resource "azurerm_storage_container" "state" {
  count                 = var.deploy_storage ? 1 : 0
  name                  = "cdmonitoring-tfstate"
  storage_account_id    = azurerm_storage_account.state[0].id
  container_access_type = "private"

  depends_on = [
    azurerm_storage_account.state
  ]
}

// User assigned identities

// Core managed identity used to create the monitoring resources for the lifecycle of the service.
resource "azurerm_user_assigned_identity" "github" {
  name                = local.mi_core_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}


resource "azurerm_federated_identity_credential" "github" {
  name                = replace(var.cd_github_repo_name, "-", "_")
  resource_group_name = azurerm_resource_group.rg.name
  parent_id           = azurerm_user_assigned_identity.github.id

  audience = ["api://AzureADTokenExchange"]
  issuer   = "https://token.actions.githubusercontent.com"
  subject  = "repo:${var.cd_github_org_name}/${var.cd_github_repo_name}:ref:refs/heads/main"
}

// Managed Identity for Azure Resource Graph based alerts
resource "azurerm_user_assigned_identity" "resource_graph" {
  name                = local.mi_arg_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

// For optional use in policy assignments. Better naming convention than the system generated name.
resource "azurerm_user_assigned_identity" "policy" {
  count               = var.deploy_policy_identity ? 1 : 0
  name                = local.mi_policy_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

// Managed Identity assigned to VMs with no permissions for AMA Agent deployment through Policy Initiative
resource "azurerm_user_assigned_identity" "vm" {
  count               = var.deploy_vm_identity ? 1 : 0
  name                = local.mi_vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

// RBAC role assignments
resource "azurerm_role_assignment" "resource_group" {
  for_each = toset(
    var.rbac ? (
      var.deploy_storage ?
      ["Azure Deployment Stack Owner", "Monitoring Contributor", "Managed Identity Operator", "Storage Blob Data Contributor"] :
      ["Azure Deployment Stack Owner", "Monitoring Contributor", "Managed Identity Operator"]
    ) : []
  )

  scope                = azurerm_resource_group.rg.id
  role_definition_name = each.value
  principal_id         = azurerm_user_assigned_identity.github.principal_id
}

resource "azurerm_role_assignment" "workspace" {
  for_each             = toset(var.rbac ? ["Monitoring Contributor"] : [])
  scope                = var.workspace_id
  role_definition_name = each.value
  principal_id         = azurerm_user_assigned_identity.github.principal_id
}

// Github Actions - Variables
resource "github_actions_variable" "github" {
  for_each = local.github_actions_variables

  repository    = var.cd_github_repo_name
  variable_name = each.key
  value         = each.value
}

// Github Actions - Secrets

resource "github_actions_secret" "client_id" {
  repository      = var.cd_github_repo_name
  secret_name     = "CLIENT_ID"
  plaintext_value = azurerm_user_assigned_identity.github.client_id
}

resource "github_actions_secret" "app_id" {
  repository      = var.cd_github_repo_name
  secret_name     = "MONITORING_MODULE_APP_ID"
  plaintext_value = "877225"
}

resource "github_actions_secret" "private_key" {
  repository      = var.cd_github_repo_name
  secret_name     = "MONITORING_MODULE_PRIVATE_KEY"
  plaintext_value = file("${path.module}/secrets/github_app.pem")
}

resource "github_actions_secret" "ssh_key" {
  repository      = var.cd_github_repo_name
  secret_name     = "SSH_KEY"
  plaintext_value = file("${path.module}/secrets/ssh_key.txt")
}

resource "github_actions_secret" "known_hosts" {
  repository      = var.cd_github_repo_name
  secret_name     = "KNOWN_HOSTS"
  plaintext_value = file("${path.module}/secrets/known_hosts.txt")
}

//Github Repository Files
resource "github_repository_file" "tfvars" {
  count               = var.deploy_storage ? 1 : 0
  repository          = var.cd_github_repo_name
  branch              = "main"
  file                = "terraform/bootstrap.auto.tfvars"
  overwrite_on_create = true

  content = <<-EOF
  subscription_id               = "${var.customer_subscription_id}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  storage_account_name          = "${azurerm_storage_account.state[0].name}"
  location                      = "${var.location}"

  tags = ${jsonencode(var.tags != null ? var.tags : {})}
  EOF
}

resource "github_repository_file" "bicep_params" {
  count               = local.create_bicep_params ? 1 : 0
  repository          = var.cd_github_repo_name
  branch              = "main"
  file                = local.bicep_file_map[local.target]
  overwrite_on_create = true

  content = templatefile(local.bicep_tpl_map[local.target], {
    location                      = var.location,
    workspace_resource_group_name = split("/", var.workspace_id)[4],
    workspace_name                = split("/", var.workspace_id)[8],
    action_group_webhook_uri      = file("${path.module}/secrets/action_group_webhook_uri.txt")
  })
}
