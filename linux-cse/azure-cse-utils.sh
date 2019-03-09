#!/bin/sh
set -e

getAzureEnvironment() {
  metadata=$(curl "http://169.254.169.254/metadata/instance/compute?api-version=2018-02-01" -H "Metadata:true")
  endpoints=$(curl "https://management.azure.com/metadata/endpoints?api-version=2017-12-01")

  location=$(echo $metadata | jq .location -r)

  # Or with true since the grep command exits with non-zero when not found
  is_ww=$(echo $endpoints | jq '.cloudEndpoint.public.locations[]' -r | grep -w $location) || true
  is_us=$(echo $endpoints | jq '.cloudEndpoint.usGovCloud.locations[]' -r | grep -w $location) || true
  is_cn=$(echo $endpoints | jq '.cloudEndpoint.chinaCloud.locations[]' -r | grep -w $location) || true
  is_de=$(echo $endpoints | jq '.cloudEndpoint.germanCloud.locations[]' -r | grep -w $location) || true

  environment="Unknown"
  if [ ! -z $is_ww ]; then environment="AzureCloud"; fi
  if [ ! -z $is_us ]; then environment="AzureUSGovernment"; fi
  if [ ! -z $is_cn ]; then environment="AzureChinaCloud"; fi
  if [ ! -z $is_de ]; then environment="AzureGermanCloud"; fi

  echo $environment
}

getAzureResourceGroup() {
  metadata=$(curl "http://169.254.169.254/metadata/instance/compute?api-version=2018-02-01" -H "Metadata:true")
  echo $(echo $metadata | jq .resourceGroupName -r)
}

installJq() {
  sudo apt-get install jq --yes
}

installAzureCli() {
  AZ_REPO=$(lsb_release -cs)
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
      tee /etc/apt/sources.list.d/azure-cli.list
  curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
  apt-get install apt-transport-https --yes
  apt-get update && sudo apt-get install azure-cli --yes
}

export get_azure_environment
export get_azure_resource_group

echo "Installing JQ"
installJq

echo "Installing Azure CLI"
installAzureCli

echo "Determining Azure Environment"
environment=$(getAzureEnvironment)
echo "Azure Environment: $environment"

echo "Logging in to Azure CLI"
az cloud set -n $environment
az login --identity

