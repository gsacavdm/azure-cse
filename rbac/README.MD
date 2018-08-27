Template to give a VM system-assigned MSI permissions at the subscription level.
This needs to be deployed after the VM ARM template before the CSE ARM template.

To deploy this one:

```bash
az deployment create -l usgovvirginia -n $(date +%Y%m%d__%H%M%S) --template-file azure-deploy.json
```