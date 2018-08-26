#!/bin/bash
set -e

Write-Host("Loading azure-cse-utils")
. $PSScriptRoot/azure-cse-utils.ps1

Write-Host("Getting VM's resource group")
$resourceGroupName = Get-AzureResourceGroup

Write-Host("Deleting " + $resourceGroupName)
Remove-AzureRmResourceGroup -Name $resourceGroupName -Force