# Running deployment scripts using an Azure VM
This is a sample Azure Resource Manager (ARM) template that you can use to launch a temporary Azure VM for deployment script execution.
The VM will launch, execute a custom script using the Custom Script Extension and then delete itself. To ensure the ARM deployment succeeds, the deletion of the VM is added as a scheduled task for the VM, instead of being executed as part of the custom script.

This template has two primary use cases:
* For deployments that do not leverage ARM templates.
* To compliment ARM-templated-based deployments that have scripts for actions not supported by ARM (e.g. create a certificate in Key Vault or upload a file to a storage account) or actions that are completely outside of ARM (e.g. bootstrap Kubernetes)

## Setup for simple deployments
For deployments that just have a few scripts, all you need to do is:
1. Publish your scripts and deployment assets (zip, json, xml, etc) to a URL that ARM can access
  * Publicly accessible endpoint like an Azure Blob Storage container with public read access, a GitHub public repository or a GitHub gist.
  * Endpoint protected by a key like a Azure Blob Storage container with a SAS key.
  * A locked-down Azure Blob Storage container. You'll need to add `storageAccountName` and `storageAccountKey` to the template's `properties.protectedSettings` section for the Custom Script Extension for this. You'll also need to make sure you host all script files (including the azure-cse-* ones) there.
1. Populate `azure-deploy.parameters.json`.
1. Modify the middle section of `azure-cse.ps1` to execute your deployment actions or call your scripts.
1. Deploy!

## To do
* Make public-ip optional through a parameter `debug`
* Add a way to log to somewhere persistent
* Add support for parameters