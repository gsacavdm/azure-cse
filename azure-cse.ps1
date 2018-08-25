Write-Host("Loading azure-cse-utils")
./azure-cse-utils.ps1

Write-Host("Running custom script")
# ****************************************************
# == This is the piece that will change ==
# ****************************************************
Write-Host "Get-AzureRmVm"
Get-AzureRmVm >> "D:\VMs.txt"

New-AzureRmResourceGroup -Name "sacagov-cse-test" -Location "usgovtexas"
# ****************************************************

Write-Host("Adding deletion scheduled task")
New-AzureDeleteResourceGroupTask
