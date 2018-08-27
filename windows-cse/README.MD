# Windows Template for Custom Script Extension
It's re-runable thanks to the everchanging ExecutionId. If this doesn't change and neither do the parameters in the template, ARM won't re-trigger the CSE. That's why the deployment syntax below sets it with the date AND TIME of the deployment. It guarantees it's always changing.

You shouldn't need to change anything in the `azure-deploy.json` and `azure-cse-*.ps1` files, these are the ones that bootstrap everything.

There's an option to delete the VM after it completes script execution. This is done by scheduling a task in Windows Scheduler, instead of being executed as part of the custom script. Including the deletion synchronously as part of the script causes the deployment to fail (it's a fake failure due to the VM being killed while the deployment is going on). Including the deletion with `-AsJob` results in a weird race condition that can succeed or can result in the async thread being killed because the CSE completes and shutdown PS, including the async thread. Overall, deleting the VM after completion isn't recommended given the hassle involved in setting up RBAC permissions which needs to happen as a subscription level deployment (vs a resource group level deployment) that happens between VM creation (and getting the MSI created) and CSE execution. Once user managed identities are available in sovereign clouds, this won't be an issue as RBAC can be setup first and the VM+CSE can be coupled and include the delete piece.


## See it in action
No setup needed, deploy by running this command:

    ```bash
    az group deployment create -g azure-cse -n $(date +%Y%m%d_%H%M%S) --template-file azure-deploy.json --parameters @examples/simple.parameters.json --parameters executionId=$(date +%Y%m%d_%H%M%S)
    ```

## Customize for your deployment
1. Publish your scripts and deployment assets (zip, json, xml, etc) to a URL that ARM can access
  * Publicly accessible endpoint like an Azure Blob Storage container with public read access, a GitHub public repository or a GitHub gist.
  * Endpoint protected by a key like a Azure Blob Storage container with a SAS key.
  * A locked-down Azure Blob Storage container. You'll need to add `storageAccountName` and `storageAccountKey` to the template's `properties.protectedSettings` section for the Custom Script Extension for this. You'll also need to make sure you host all script files (including the azure-cse-* ones) there.
1. Create your own parameters file, you can start off with `examples/simple.parameters.json` and modify it accordingly.
1. Deploy by running this command:

    ```bash
    az group deployment create -g azure-cse -n $(date +%Y%m%d_%H%M%S) --template-file azure-deploy.json --parameters @yourown.parameters.json --parameters executionId=$(date +%Y%m%d_%H%M%S)
    ```

## Troubleshooting
The custom script extension does not log the std out and std err of PS and I haven't implemented any logging yet, so if the script fails, you'll have to:
1. Remote into the cse machine
1. Get in the same security context as the CSE:
    1. Download SysInternals' PSExec on the box (you'll need to disable IE Enhanced Security Configuration).
    1. Launch a command prompt as admin
    1. From the command prompt, launch psexec as follows:

        ```cmd
        psexec -i -s cmd
        ```

1. From the new command prompt, emulate the VM CSE as follows:

    ```cmd
    cmd /C "powershell -ExecutionPolicy Unrestricted -File youscript.ps1 -YourParameter YouParameterValue
    ```
