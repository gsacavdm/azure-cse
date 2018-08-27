param (
  [bool] $DeleteAfterDone = $false,
  [string] $ExecutionId  = "",

  # Replace with your own parameters:
  [string] $File,
  [string] $StorageAccountName
)

$ErrorActionPreference = "Stop"

Write-Host("Loading azure-cse-utils")
. ./azure-cse-utils.ps1

Write-Host("Running custom script")
$metadataResponse = Invoke-WebRequest "http://169.254.169.254/metadata/instance/compute?api-version=2018-02-01" -H @{"Metadata"="true"}
$metadata = ConvertFrom-Json ($metadataResponse.Content)

$resourceGroupName = $metadata.resourceGroupName
$location = $metadata.location

$storageAccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup | Where StorageAccountName -match $storageAccountName

if (!($exists)) {
  $storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName `
    -Location $location `
    -SkuName Standard_LRS `
    -Kind Storage
}

$ctx = $storageAccount.Context

$containerName = "quickstartblobs"
New-AzureStorageContainer -Name $containerName -Context $ctx -Permission blob

Set-AzureStorageBlobContent -File $File `
  -Container $containerName `
  -Blob $File `
  -Context $ctx 

if ($DeleteAfterDone) {
  Write-Host("Adding deletion scheduled task")
  New-AzureDeleteResourceGroupTask
}