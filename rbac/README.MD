Template to give a VM system-assigned MSI permissions at the subscription level.

Sample deployment:

```bash
az deployment create -l usgovvirginia -n $(date +%Y%m%d__%H%M%S) --template-file azure-deploy.json
```