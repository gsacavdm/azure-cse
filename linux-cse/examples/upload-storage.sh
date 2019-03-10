#!/bin/bash

execution_id=$1

# Replace with your own parameters:
file=$2
storage_account_name=$3
storage_container_name=$4

set -e

echo "Loading azure-cse-utils"
. ./azure-cse-utils.sh

echo "Looking up blob $storage_account_name..."
storage_account=$(az storage account list --query "[?name=='$storage_account_name'].name" -o json | jq -r '.[0]')
if [ "$storage_account" == "null" ]
then
  resource_group=$(getAzureResourceGroup)

  echo "Storage account $storage_account_name not found, creating in resource group $resource_group..."
  az storage account create -g $resource_group -n $storage_account_name
fi

echo "Getting storage account $storage_account_name key..."
storage_account_key=$(az storage account keys list -n $storage_account_name --query "[0].value" -o tsv)

echo "Setting storage environment variables"
export AZURE_STORAGE_ACCOUNT=$storage_account_name
export AZURE_STORAGE_KEY=$storage_account_key

echo "Looking up container $storage_container_name in storage account $storage_account_name..."
storage_container=$(az storage container list --query "[?name=='$storage_container_name'].name" -o json | jq -r '.[0]')
if [ "$storage_container" == "null" ]
then
  echo "Container $storage_container_name in storage account $storage_account_name not found, creating..."
  az storage container create -n $storage_container_name
fi

echo "Uploading file $file to storage account $storage_account_name, container $storage_container_name..."
az storage blob upload -n $(basename $file) -c $storage_container_name -f $file

echo "Done!"