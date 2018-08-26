param (
  [bool] $DeleteAfterDone = $false,
  [string] $ExecutionId  = "",

  # Replace with your own parameters:
  [string] $ExampleParam = "ExampleParamDefaultValue"
)

$ErrorActionPreference = "Stop"

Write-Host("Loading azure-cse-utils")
. ./azure-cse-utils.ps1

Write-Host("Running custom script")
# ****************************************************
# == Custom Script Exeuction/Bootstrapping ==
# ****************************************************
# Modify this section to either:
# a) Execute scripting actions directly in here
# b) Call any script you added to the arguments parameter
# c) Unzip your deployment scripts & tools you added to the arguments parameters and kick-off your main deployment script

# Sample script hosted in a GitHub gist
./azure-deploy.ps1 -ExampleParam $ExampleParam
# ****************************************************

if ($DeleteAfterDone) {
  Write-Host("Adding deletion scheduled task")
  New-AzureDeleteResourceGroupTask
}