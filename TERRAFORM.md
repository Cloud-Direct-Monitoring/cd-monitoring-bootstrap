<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.0.1 |
| <a name="provider_github"></a> [github](#provider\_github) | 6.2.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.github](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.state](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.state](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_user_assigned_identity.github](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [github_actions_secret.app_id](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.client_id](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.known_hosts](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.private_key](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.ssh_key](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_variable.github](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
| [github_repository_file.bicep_params](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.tfvars](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cd_github_org_name"></a> [cd\_github\_org\_name](#input\_cd\_github\_org\_name) | Specify the GitHub Organization | `string` | `"Cloud-Direct-Monitoring"` | no |
| <a name="input_cd_github_pat_value"></a> [cd\_github\_pat\_value](#input\_cd\_github\_pat\_value) | Value of the GitHub fine grained personal access token | `string` | n/a | yes |
| <a name="input_cd_github_repo_name"></a> [cd\_github\_repo\_name](#input\_cd\_github\_repo\_name) | The name of the customer GitHub repository. | `string` | n/a | yes |
| <a name="input_customer_subscription_id"></a> [customer\_subscription\_id](#input\_customer\_subscription\_id) | Azure subscription GUID for the deployed resources. | `string` | n/a | yes |
| <a name="input_customer_subscription_name"></a> [customer\_subscription\_name](#input\_customer\_subscription\_name) | Cosmetic name for the Azure subscription. For Azure Landing Zone, the Management subscription is recommended. | `string` | `"Management"` | no |
| <a name="input_customer_tenant_id"></a> [customer\_tenant\_id](#input\_customer\_tenant\_id) | The customer's Entra ID tenant GUID. | `string` | n/a | yes |
| <a name="input_customer_tenant_name"></a> [customer\_tenant\_name](#input\_customer\_tenant\_name) | Cosmetic name for the customer tenant. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Specify the Azure region to deploy into. | `string` | `"UK South"` | no |
| <a name="input_rbac"></a> [rbac](#input\_rbac) | Specify whether to create the RBAC roles. Set to false if terraform is not running with a privileged account. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Display name for the resource group | `string` | `null` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Display name of the storage account for the Terraform state | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Specify a map if tags to apply to the resources. | `map(string)` | `null` | no |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | The Log Analytics workspace ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_repository"></a> [client\_repository](#output\_client\_repository) | n/a |
| <a name="output_client_repository_url"></a> [client\_repository\_url](#output\_client\_repository\_url) | n/a |
| <a name="output_federated_credential_subject"></a> [federated\_credential\_subject](#output\_federated\_credential\_subject) | n/a |
| <a name="output_rbac_commands"></a> [rbac\_commands](#output\_rbac\_commands) | n/a |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | n/a |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | n/a |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | n/a |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | n/a |
| <a name="output_user_assigned_identity_client_id"></a> [user\_assigned\_identity\_client\_id](#output\_user\_assigned\_identity\_client\_id) | n/a |
| <a name="output_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#output\_user\_assigned\_identity\_id) | n/a |
| <a name="output_user_assigned_identity_principal_id"></a> [user\_assigned\_identity\_principal\_id](#output\_user\_assigned\_identity\_principal\_id) | n/a |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | n/a |
<!-- END_TF_DOCS -->