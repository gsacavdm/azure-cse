$ErrorActionPreference = "Stop"

# Since this script runs from Task Scheduler
# We want to ensure the working directory is correct
cd $PSScriptRoot

Write-Host("Loading azure-cse-utils")
. ./azure-cse-utils.ps1

Write-Host("Getting VM's resource group")
$resourceGroupName = Get-AzureResourceGroup

Write-Host("Deleting " + $resourceGroupName)
Remove-AzureRmResourceGroup -Name $resourceGroupName -Force