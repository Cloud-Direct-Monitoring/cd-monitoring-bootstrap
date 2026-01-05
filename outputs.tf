output "rbac_commands" {
  value = var.rbac ? null : <<-EOF

  az role assignment create --assignee ${azurerm_user_assigned_identity.github.principal_id} --role "Azure Deployment Stack Owner" \
    --scope ${azurerm_resource_group.rg.id}

  az role assignment create --assignee ${azurerm_user_assigned_identity.github.principal_id} --role "Monitoring Contributor" \
    --scope ${azurerm_resource_group.rg.id}

  az role assignment create --assignee ${azurerm_user_assigned_identity.github.principal_id} --role "Storage Blob Data Contributor" \
    --scope ${azurerm_resource_group.rg.id}

  az role assignment create --assignee ${azurerm_user_assigned_identity.github.principal_id} --role "Contributor" \
    --scope ${var.workspace_id}

  EOF
}

output "workspace_id" {
  description = "The Resource Id of the Log Analytics Workspace"
  value = var.workspace_id
}

output "resource_group_id" {
  description = "The Resource Id of the Resource Group"
  value = azurerm_resource_group.rg.id
}

output "user_assigned_identity_id" {
  description = "The Resource Id of the User Assigned Identity"
  value = azurerm_user_assigned_identity.github.id
}

output "user_assigned_identity_client_id" {
  description = "The Client Id of the User Assigned Identity"
  value = azurerm_user_assigned_identity.github.client_id
}

output "user_assigned_identity_principal_id" {
  description = "The Principal Id of the User Assigned Identity"
  value = azurerm_user_assigned_identity.github.principal_id
}

output "storage_account_id" {
  value       = var.deploy_storage ? azurerm_storage_account.state[0].id : null
  description = "Resource Id of the deployed storage account (if any)"
}

output "storage_account_name" {
  value       = var.deploy_storage ? azurerm_storage_account.state[0].name : null
  description = "Name of the deployed storage account (if any)"
}

output "tenant_id" {
  value = var.customer_tenant_id
  description = "The Tenant Id of the customer"
}

output "subscription_id" {
  value = var.customer_subscription_id
  description = "The Subscription Id of the customer"
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
  description = "The name of the Resource Group"
}

output "federated_credential_subject" {
  value = azurerm_federated_identity_credential.github.subject
  description = "The subject configured in the Federated Identity Credential for GitHub Actions"
}

output "client_repository" {
  value = var.cd_github_repo_name
  description = "The name of the GitHub repository used for client deployment"
}

output "client_repository_url" {
  value = "https://github.com/${var.cd_github_org_name}/${var.cd_github_repo_name}"
  description = "The URL of the GitHub repository used for client deployment"
}
