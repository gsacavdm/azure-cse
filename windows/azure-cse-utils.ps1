function Get-AzureEnvironment () {
  $metadataResponse = Invoke-WebRequest "http://169.254.169.254/metadata/instance/compute?api-version=2018-02-01" -H @{"Metadata"="true"} -UseBasicParsing
  $metadata = ConvertFrom-Json ($metadataResponse.Content)

  $endpointsResponse = Invoke-WebRequest "https://management.azure.com/metadata/endpoints?api-version=2017-12-01" -UseBasicParsing
  $endpoints = ConvertFrom-Json ($endpointsResponse.Content)

  foreach ($cloud in $endpoints.cloudEndpoint.PSObject.Properties) {
    $matchingLocation = $cloud.Value.locations | Where-Object {$_ -match $metadata.location}
    if ($matchingLocation) { 
      $cloudName = $cloud.name
      break
    }
  }

  $environment = "Unknown"
  switch ($cloudName) {
    "public" { $environment = "AzureCloud"}
    "usGovCloud" { $environment = "AzureUSGovernment"}
    "chinaCloud" { $environment = "AzureChinaCloud"}
    "germanCloud" { $environment = "AzureGermanCloud"}
  }

  return $environment
}

function Get-AzureResourceGroup () {
  $metadataResponse = Invoke-WebRequest "http://169.254.169.254/metadata/instance/compute?api-version=2018-02-01" -H @{"Metadata"="true"} -UseBasicParsing
  $metadata = ConvertFrom-Json ($metadataResponse.Content)

  return $metadata.ResourceGroupName
}

function New-AzureDeleteResourceGroupTask() {  
  $taskAction = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "$pwd\azure-cse-delete.ps1"
  $taskTrigger = New-ScheduledTaskTrigger -Once -At ((Get-Date).AddMinutes(5))
  $taskPrincipal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
  $taskSettings = New-ScheduledTaskSettingsSet
  $task = New-ScheduledTask -Action $taskAction -Principal $taskPrincipal -Trigger $taskTrigger -Settings $taskSettings

  Register-ScheduledTask T1 -InputObject $task
}

if (!(Get-PackageProvider | Where-Object Name -match NuGet)) {
  Write-Host "Installing NuGet"
  Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
}

if (!(Get-Module -ListAvailable AzureRM)) {
  Write-Host "Installing AzureRM"
  Install-Module AzureRM -Force
}

$environment = Get-AzureEnvironment
Login-AzureRmAccount -Identity -Environment $environment