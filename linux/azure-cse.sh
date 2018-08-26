#!/bin/bash
set -e

echo "Loading azure-cse-utils"
./azure-cse-utils.sh

echo "Running custom script"
# ****************************************************
# == This is the piece that will change ==
# ****************************************************
echo "Get-AzureRmVm"
az vm list >> "/tmp/VMs.txt"
# ****************************************************

echo "Scheduling deletion"
#New-AzureDeleteResourceGroupTask
