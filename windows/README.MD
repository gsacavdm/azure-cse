# Running Deployment Scripts using an Azure VM
This is a sample Azure Resource Manager (ARM) template that you can use to launch a temporary Azure VM for deployment script execution.
The VM will launch, execute a custom script using the Custom Script Extension and then delete itself. To ensure the ARM deployment succeeds, the deletion of the VM is added as a scheduled task for the VM, instead of being executed as part of the custom script.

## ToDo
* Make public-ip optional through a parameter `debug` or something
* Fix Gov hardcoded references (e.g. `usgovcloudapi.net`)
* In script, detect cloud and VM name using IMDS