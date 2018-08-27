#!/bin/sh

delete_after_done=$0
execution_id=$1

# Replace with your own parameters:
file=$2
storage_account_name=$3

set -e

echo "Loading azure-cse-utils"
. ./azure-cse-utils.sh

echo "Running custom script"
metadata=$(curl "http://169.254.169.254/metadata/instance/compute?api-version=2018-02-01" -H "Metadata:true")
resource_group_name=$(echo $metadata | jq .resourceGroupName -r)
location=$(echo $metadata | jq .location -r)

storage_account=$(az storage account list | grep -w $storage_account_name)

if [ ! -z $storage_account ]; then
  az storage account create -g $resource_group_name -n  $storage_account_name -l $location --sku Standard_LRS --kind Storage
fi