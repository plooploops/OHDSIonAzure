# Quickstart - Creating your Environment Notes

This guide will let you work through the E2E for setting up your environment in your Azure subscription and Azure DevOps project.

## Prerequisites

You will need to work with your administrator to ensure you can setup the following tools to provision OHDSI on Azure within your Azure subscription:

1. You and your Administrator have access to your Azure Subscription
    * Make sure you have [installed Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and you have [logged in](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli) to your Azure Subscription to confirm access
    * You can use the following steps to login to your subscription:
      1. `az login`
      2. `az account set -s <my-subscription-id>`
      3. `az account show` to confirm you have logged in

2. Work with your administrator to ensure you have the following permissions:

* For [Azure AD](/infra/terraform/bootstrap/README.md#azure-ad-permissions) you should be able to set the following for an Azure Service Principal:
  * [Groups Administrator](https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference#groups-administrator)
  * [User Administrator](https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference#user-administrator)
  * [Application administrator](https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference#application-administrator)
  * [Privileged Role Administrator](https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference#privileged-role-administrator)

* For your [Azure DevOps PAT](/infra/terraform/bootstrap/README.md#ado-pat-notes), your Azure DevOps credential should include the following:

* Agent Pools - Read & Manage
* Build - Read & Execute
* Code - Full
* Environment - Read & Manage
* Extension Data - Read & Write
* Extensions - Read & Manage
* Project and Team - Read, Write, & Manage
* Service Connections - Read, Query, & Manage
* Token Administration - Read & Manage
* Tokens - Read & Manage
* User Profile - Read & Write
* Variable Groups - Read, Create, & Manage
* Work Items - Read

> And your Azure DevOps administrator account should be assigned [project collection administrators group](https://docs.microsoft.com/en-us/azure/devops/organizations/security/change-organization-collection-level-permissions?view=azure-devops&tabs=preview-page#add-members-to-the-project-collection-administrators-group)

3. You are able to [setup porter](/local_development_setup.md#setup-porter):

> This step assumes you have setup [docker](/local_development_setup.md#setup-local-tools) and that you have appropriate execution permissions within your shell context.
> For WSL, you may need to run `dos2unix` on the shell scripts from the repository root:

```shell
sudo apt install dos2unix # install dos2unix
find . -name '*.sh' -exec dos2unix {} + # convert scripts
```

The following example uses `bash`:

* Set your shell script file permissions so you can execute the scripts

```shell
find . -name '*.sh' -exec chmod +x {} + # enable execution permission on your shell scripts from the repository root
```

* Run the setup script to setup porter

```shell
./setup.sh \
    --AZURE_SERVICE_PRINCIPAL_NAME "myOHDSIOnAzureSP" \
    --BOOTSTRAP_TF_BACKEND_STORAGE_ACCOUNT_NAME "mybootstraptfstatesa" \
    --BOOTSTRAP_TF_BACKEND_RESOURCE_GROUP_NAME "my-bootstrap-rg" \
    --BOOTSTRAP_TF_BACKEND_STORAGE_ACCOUNT_CONTAINER_NAME "my-tfstate" \
    --ADO_PAT "my-Azure-DevOps-PAT" \
    --OMOP_PASSWORD "replaceMyP@SSW0RD" \
    --ADMIN_USER_JUMPBOX "azureuser" \
    --ADMIN_PASSWORD_JUMPBOX "replaceMyP@SSW0RD@ls0" \
    --ADMIN_USER "azureuser" \
    --ADMIN_PASSWORD "replaceMyP@SSW0RDT00" \
    --PREFIX "ohdsi" \
    --ENVIRONMENT "dev01" \
    --ADO_ORGANIZATION_NAME "my-ADO-organization-name"
```

* The setup script should setup your backend Azure Storage account for your bootstrap, install porter, and setup an OHDSI on Azure environment configuration file, which you can pull into your local environment with the following command:

```shell
# This command should be an output from the setup.sh call
source "ohdsi-dev01-OHDSIOnAzure.env"
```

## Setup Steps

Once you have your permissions setup along with porter, you can proceed to setup your OHDSI on Azure environment.

### Step 1. Porter Build

OHDSI on Azure uses [Porter](https://porter.sh/docs/) to have a build environment wrapped in an OCI container to capture dependencies and setup steps in a [CNAB (Cloud Native Application Bundle)](https://github.com/cnabio/cnab-spec) bundle manifest.  Using a bundle will provide a consistent build and deployment experience for OHDSI on Azure.

You can perform a local build for porter with the following command:

```shell
porter build
```

### Step 2. Install the bootstrap

Assuming you have setup porter and can build successfully, you can now use your OHDSI on Azure bundle to install the [bootstrap](/infra/terraform/bootstrap/README.md):

```shell
porter install \
    --cred ./creds.json \
    -p ./parameters.json
```

### Step 3. Setup your Environment

Once you have successfully installed the [bootstrap](/infra/terraform/bootstrap/README.md), you can now work through the following actions in order to setup your OHDSI on Azure Environment.

1. You can call the action `deploy-environment` to deploy your [environment](/pipelines/README.md#environment-pipeline):

```shell
porter invoke --action deploy-environment \
    --cred ./creds.json \
    -p ./parameters.json
```

2. You can call the action `deploy-vocabulary` to deploy your [vocabulary](/pipelines/README.md#vocabulary-pipelines):

```shell
porter invoke --action deploy-vocabulary \
    --cred ./creds.json \
    -p ./parameters.json
```

3. You can call the action `deploy-broadsea` to deploy [broadsea](/pipelines/README.md#broadsea-pipelines) to your OHDSI on Azure environment:

```shell
porter invoke --action deploy-broadsea \
    --cred ./creds.json \
    -p ./parameters.json
```

### Step 4. Clean up your environment

If you're finished working with OHDSI on Azure, you can use the `uninstall` command to clean up your Azure deployment:

```shell
porter install \
    --cred ./creds.json \
    -p ./parameters.json
```
