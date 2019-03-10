#!/bin/bash

execution_id=$1

# Replace with your own parameters:
resource_group_name=$2
resource_group_location=$3

set -e

echo "Loading azure-cse-utils"
. ./azure-cse-utils.sh

echo "Running custom script"
# ****************************************************
# == Custom Script Execution/Bootstrapping ==
# ****************************************************
# Modify this section to either:
# a) Execute scripting actions directly in here
# b) Call any script you added to the arguments parameter
# c) Unzip your deployment scripts & tools you added to the arguments parameters and kick-off your main deployment script

# Sample script hosted in a GitHub gist
echo "az vm list"
az vm list >> "/tmp/VMs.txt"

echo "az group create"
az group create -n $resource_group_name -l $resource_group_location

echo "Done"