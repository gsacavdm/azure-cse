# Running deployment scripts using an Azure VM
This repo has several Azure Resource Manager (ARM) templates that you can use to setup an Azure VM for deployment script execution.

There are three ARM templates involved:
1. VM template - Creates the VM with a managed service identity (MSI).
1. RBAC template - Grants the VM's MSI subscription owner rights so that it can create new resource groups and resources.
1. Custom script extension (CSE) template - Launches the deployment script.

This setup has two primary use cases:
* For deployments that do not leverage ARM templates.
* To compliment ARM-templated-based deployments that have scripts for actions not supported by ARM (e.g. create a certificate in Key Vault or upload a file to a storage account) or actions that are completely outside of ARM (e.g. bootstrap Kubernetes)

## To do
* Add a way to log to somewhere persistent
* Don't download AzureRM PS module via Nuget, include zipped module in fileUris, unzip and load.
* Switch Windows image to Win10 so that we don't need UseBasicParsing
* Test for Azure China, in particular call to `management.azure.com` in `azure-cse-utils.ps1`
* Make public-ip optional through a parameter `debug`
* Add Linux VM and Linux CSE
