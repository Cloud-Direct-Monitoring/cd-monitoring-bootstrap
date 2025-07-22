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
  value = var.workspace_id
}

output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "user_assigned_identity_id" {
  value = azurerm_user_assigned_identity.github.id
}

output "user_assigned_identity_client_id" {
  value = azurerm_user_assigned_identity.github.client_id
}

output "user_assigned_identity_principal_id" {
  value = azurerm_user_assigned_identity.github.principal_id
}

output "storage_account_id" {
  value       = var.deploy_storage ? azurerm_storage_account.state[0].id : null
  description = "Resource Id of the deployed storage account (if any"
}

output "storage_account_name" {
  value       = var.deploy_storage ? azurerm_storage_account.state[0].name : null
  description = "Name of the deployed storage account (if any"
}

output "tenant_id" {
  value = var.customer_tenant_id
}

output "subscription_id" {
  value = var.customer_subscription_id
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "federated_credential_subject" {
  value = azurerm_federated_identity_credential.github.subject
}

output "client_repository" {
  value = var.cd_github_repo_name
}

output "client_repository_url" {
  value = "https://github.com/${var.cd_github_org_name}/${var.cd_github_repo_name}"
}
