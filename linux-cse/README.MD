# Linux Template for Custom Script Extension
It's re-runable thanks to the everchanging ExecutionId. If this doesn't change and neither do the parameters in the template, ARM won't re-trigger the CSE. That's why the deployment syntax below sets it with the date AND TIME of the deployment. It guarantees it's always changing.

You shouldn't need to change anything in the `azure-deploy.json` and `azure-cse-*.sh` files, these are the ones that bootstrap everything.

There's an option to delete the VM after it completes script execution. Overall, deleting the VM after completion isn't recommended given the hassle involved in setting up RBAC permissions which needs to happen as a subscription level deployment (vs a resource group level deployment) that happens between VM creation (and getting the MSI created) and CSE execution. Once user managed identities are available in sovereign clouds, this won't be an issue as RBAC can be setup first and the VM+CSE can be coupled and include the delete piece.


## See it in action
No setup needed, deploy by running this command:

    ```bash
    az group deployment create -g azure-cse-linux -n $(date +%Y%m%d_%H%M%S) --template-file azure-deploy.json --parameters @examples/simple.parameters.json --parameters executionId=$(date +%Y%m%d_%H%M%S)
    ```

## Customize for your deployment
1. Publish your scripts and deployment assets (zip, json, xml, etc) to a URL that ARM can access
  * Publicly accessible endpoint like an Azure Blob Storage container with public read access, a GitHub public repository or a GitHub gist.
  * Endpoint protected by a key like a Azure Blob Storage container with a SAS key.
  * A locked-down Azure Blob Storage container. You'll need to add `storageAccountName` and `storageAccountKey` to the template's `properties.protectedSettings` section for the Custom Script Extension for this. You'll also need to make sure you host all script files (including the azure-cse-* ones) there.
1. Create your own parameters file, you can start off with `examples/simple.parameters.json` and modify it accordingly.
1. Deploy by running this command:

    ```bash
    az group deployment create -g azure-cse-linux -n $(date +%Y%m%d_%H%M%S) --template-file azure-deploy.json --parameters @yourown.parameters.json --parameters executionId=$(date +%Y%m%d_%H%M%S)
    ```

## Troubleshooting
TBD