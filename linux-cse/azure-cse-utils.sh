#!/bin/sh

function get-azure-environment () {
  local metadata=$(curl "http://169.254.169.254/metadata/instance/compute?api-version=2018-02-01" -H "Metadata:true")
  local endpoints=$(curl "https://management.azure.com/metadata/endpoints?api-version=2017-12-01")

  local location=$(echo $metadata | jq .location -r)

  is_ww=$(echo $endpoints | jq '.cloudEndpoint.public.locations[]' -r | grep -w $location)
  is_us=$(echo $endpoints | jq '.cloudEndpoint.usGovCloud.locations[]' -r | grep -w $location)
  is_cn=$(echo $endpoints | jq '.cloudEndpoint.chinaCloud.locations[]' -r | grep -w $location)
  is_de=$(echo $endpoints | jq '.cloudEndpoint.germanCloud.locations[]' -r | grep -w $location)

  environment="Unknown"
  if [ ! -z $is_ww ]; then environment="AzureCloud"; fi
  if [ ! -z $is_us ]; then environment="AzureUSGovernment"; fi
  if [ ! -z $is_cn ]; then environment="AzureChinaCloud"; fi
  if [ ! -z $is_de ]; then environment="AzureGermanCloud"; fi

  return $environment
}

function get_azure_resource_group () {
  local metadata=$(curl "http://169.254.169.254/metadata/instance/compute?api-version=2018-02-01" -H "Metadata:true")
  return $(echo $metadata | jq .resourceGroupName -r)
}

function install_cli () {
  AZ_REPO=$(lsb_release -cs)
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
      sudo tee /etc/apt/sources.list.d/azure-cli.list
  curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
  sudo apt-get install apt-transport-https
  sudo apt-get update && sudo apt-get install azure-cli
}

environment=$(get_azure_environment())
az cloud set -s $environment
az login --identity