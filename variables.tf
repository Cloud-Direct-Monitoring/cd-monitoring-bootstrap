// Required values

variable "customer_tenant_id" {
  description = "The customer's Entra ID tenant GUID."
  type        = string

  validation {
    condition     = length(var.customer_tenant_id) == 36
    error_message = "The customer_tenant_id must be a valid GUID."
  }
}

variable "customer_tenant_name" {
  description = "Cosmetic name for the customer tenant."
  type        = string

  validation {
    condition     = length(var.customer_tenant_name) > 0
    error_message = "The customer_tenant_name must be a valid string."
  }
}

variable "customer_subscription_id" {
  description = "Azure subscription GUID for the deployed resources."
  type        = string

  validation {
    condition     = length(var.customer_subscription_id) == 36
    error_message = "The customer_subscription_id must be a valid GUID."
  }
}

variable "deploy_storage" {
  description = "Whether to deploy the storage account for Terraform state"
  type        = bool
  default     = true
}

variable "deploy_policy_identity" {
  description = "Whether to deploy the policy managed identity"
  type        = bool
  default     = true
}

variable "deploy_vm_identity" {
  description = "Whether to deploy the VM managed identity"
  type        = bool
  default     = true
}

variable "customer_subscription_name" {
  description = "Cosmetic name for the Azure subscription. For Azure Landing Zone, the Management subscription is recommended."
  default     = "Management"
  type        = string

  validation {
    condition     = length(var.customer_subscription_name) > 0
    error_message = "The customer_subscription_name must be a valid string."
  }
}

variable "cd_github_repo_name" {
  description = "The name of the customer GitHub repository."
  type        = string
}

variable "cd_github_pat_value" {
  description = "Value of the GitHub fine grained personal access token"
  type        = string

  validation {
    condition     = length(var.cd_github_pat_value) > 0
    error_message = "The cd_github_pat_value must be a valid string."

  }
}

variable "workspace_id" {
  description = "The Log Analytics workspace ID."
  type        = string

  validation {
    condition     = length(var.workspace_id) > 0 && can(regex("^/subscriptions/.*/resource[Gg]roups/.*/providers/.*", var.workspace_id))
    error_message = "The workspace_id must be a valid resource ID."
  }
}

// Defaulted variables

variable "rbac" {
  description = "Specify whether to create the RBAC roles. Set to false if terraform is not running with a privileged account."
  default     = true
  type        = bool
}

variable "location" {
  description = "Specify the Azure region to deploy into."
  default     = "UK South"
  type        = string
}

variable "resource_group_name" {
  description = "Display name for the resource group"
  default     = null
  type        = string
}

variable "region_short" {
  type = string
}

variable "storage_account_name" {
  description = "Display name of the storage account for the Terraform state"
  default     = null
  type        = string

  validation {
    condition     = var.storage_account_name == null ? true : (length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24 && can(regex("^[a-z0-9]*$", var.storage_account_name)))
    error_message = "The storage account name must be between 3 and 24 characters, and use only lowercase letters and numbers."
  }
}

variable "cd_github_org_name" {
  description = "Specify the GitHub Organization"
  default     = "Cloud-Direct-Monitoring"
  type        = string
}

// Tagging variables

variable "tags" {
  description = "Specify a map if tags to apply to the resources."
  default     = null
  type        = map(string)
}
