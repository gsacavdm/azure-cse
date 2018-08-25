./azure-cse-utils.ps1

$resourceGroupName = Get-AzureResourceGroup

Write-Host("Deleting " + $resourceGroupName)
Remove-AzureRmResouceGroup -Name $resourceGroupName