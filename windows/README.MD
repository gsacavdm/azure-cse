# Running deployment scripts using an Azure VM
This is a sample Azure Resource Manager (ARM) template that you can use to launch a temporary Azure VM for deployment script execution.
The VM will launch, execute a custom script using the Custom Script Extension and then delete itself. 

To ensure the ARM deployment succeeds, the deletion of the VM is added as a scheduled task for the VM, instead of being executed as part of the custom script. The delete resource group task is scheduled to kick off 5 minutes after the deployment script completes and is visible via the Windows Task Scheduler.

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

    ```bash
    az group deployment create -g azure-cse -n $(date +%Y%m%d_%H%M%S) --template-file azure-deploy.json --parameters @examples/simple.parameters.json --parameters adminUsername=azure-cse-admin --parameters adminPassword=$PASSWORD --parameters executionId=$(date +%Y%m%d_%H%M%S)
    ```

## Troubleshooting
If the script fails, it won't schedule the delete task and even if it succeeds, you have 5 minutes to remote into the machine and poke around.

If you want to emulate script exection:
1. Remote into the cse machine
1. Download SysInternals' PSExec on the box (you'll need to disable IE Enhanced Security Configuration).
1. Launch a command prompt as admin
1. From the command prompt, launch psexec as follows:

    ```cmd
    psexec -i -s cmd
    ```

1. From the new command prompt, emulate the VM CSE as follows:

    ```cmd
    cmd /C "powershell -ExecutionPolicy Unrestricted -File azure-cse.ps1
    ```

    Append any parameters you added (e.g. `-ExampleParam example`)


## To do
* Split VM from CSE
* Add a way to log to somewhere persistent
* Don't download AzureRM PS module via Nuget, include zipped module in fileUris, unzip and load.
* Switch Windows image to Win10 so that we don't need UseBasicParsing
* Test for Azure China, in particular call to `management.azure.com` in `azure-cse-utils.ps1`
* Make public-ip optional through a parameter `debug`
