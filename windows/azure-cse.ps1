$ErrorActionPreference = "Stop"

Write-Host("Loading azure-cse-utils")
. $PSScriptRoot/azure-cse-utils.ps1

Write-Host("Running custom script")
# ****************************************************
# == This is the piece that will change ==
# ****************************************************
Write-Host "Get-AzureRmVm"
Get-AzureRmVm >> "D:\VMs.txt"
# ****************************************************

Write-Host("Adding deletion scheduled task")
New-AzureDeleteResourceGroupTask
