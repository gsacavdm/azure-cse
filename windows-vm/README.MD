This is the ARM Template for the Windows VM that will run the scripts.
Run this first, then the RBAC template and finally run the windows-cse template.

To deploy this one:

    ```bash
    az group deployment create -g azure-cse -n $(date +%Y%m%d_%H%M%S) --template-file azure-deploy.json --parameters @azure-deploy.parameters.json --parameters adminUsername=azure-cse-admin --parameters adminPassword=$PASSWORD
    ```
