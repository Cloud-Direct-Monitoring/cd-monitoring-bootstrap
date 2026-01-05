<p>
<img src="./src/img/cloud_direct_logo.svg" alt="cloud-direct-logo" width="300" height="auto">
</p>

[![Validation Workflow](https://github.com/Cloud-Direct-Monitoring/cd-monitoring-bootstrap/actions/workflows/validation.yml/badge.svg)](https://github.com/Cloud-Direct-Monitoring/cd-monitoring-bootstrap/actions/workflows/validation.yml)
[![Release Workflow](https://github.com/Cloud-Direct-Monitoring/cd-monitoring-bootstrap/actions/workflows/release.yml/badge.svg)](https://github.com/Cloud-Direct-Monitoring/cd-monitoring-bootstrap/actions/workflows/release.yml)

[![renovate](https://img.shields.io/badge/renovate-enabled-brightgreen?style=for-the-badge&logo=renovate)](https://github.com/renovatebot/renovate)

# cd-monitoring-bootstrap

Repository to bootstrap a customer environment for the deployment of monitoring resources.

## Prereqs

You will need to install the Azure CLI and the Terraform tooling:

[Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

[Terraform](https://developer.hashicorp.com/terraform/install)

The onboarding engineer will provide a set of info for the bootstrap process:


* client repo name

    The name of a customer repo from the template repo in the https://github.com/Cloud-Direct-Monitoring organisation.

* personal access token (PAT)

    A short-lived personal access token to allow this repo to write files, secrets and variables to that client repo.

* secret files

    A set of files downloaded from the <https://github.com/Cloud-Direct-Monitoring/cd-monitoring-secrets> repo.

You will also need the git binary installed on your machine. Visual Studio Code is also assumed in this guide.

## Clone

1. Clone the repo

    ```shell
    git clone https://github.com/Cloud-Direct-Monitoring/cd-monitoring-bootstrap customer
    ```

     Change `customer` to a customer shortcode.

1. Change directory

    ```shell
    cd customer
    ```

1. Open Visual Studio Code

   ```shell
   code .
   ```

## Customise

An terraform.tfvars file has been provided.

1. Rename terraform.tfvars.example, removing the .example extension
1. Customise the values
    * Specify the provided GitHub repo name and access token.
    * You will also need the resource ID for an existing Azure Monitor workspace. This will be used by the Data Collection Rule.

    > Note that additional variables are defined in variables.tf.

1. Save the terraform.tfvars file
1. Save the secrets files into the secrets folder

## Authenticate

1. Log into the customer environment
1. Set the context to the correct subscription

## Deploy

1. Validate

    ```shell
    terraform validate
    ```

    This will check that you have all of the expected secrets and variable values.

1. Plan

    ```shell
    terraform plan
    ```

1. Apply

    ```shell
    terraform apply
    ```

## Checks

Once deployed, you should see the new resource group in the selected subscription.

If you have not specified a resource group name then it will default to rg-cdmonitoring-prod-uksouth-001.

The resource group will contain:

* managed identity with
    * least privilege RBAC roles on the resource group scope
    * federated credential to enable the workflows to use OpenID Connect
* storage account and a single container
    * ready for use as a remote state by Terraform

The client repo will also have a number of variables and secrets, plus parameter files.

## Success

The workflows in the client repo may now be run by Managed Services.

Once deployed, the Azure Monitor Agent policies can be deployed to specify the new Data Collection Rule.
