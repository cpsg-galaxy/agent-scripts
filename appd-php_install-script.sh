#!/bin/bash

#Reference userenv
. /usr/local/osmosix/service/utils/agent_util.sh
source /usr/local/osmosix/etc/userenv

agentSendLogMessage "Installing AppDynamics Agent..."

# Setting the script to exit immediately on any command failure
set -e
set -o pipefail

# Add Host file entry for appd-controller

sudo echo "$2	appd-controller" | sudo tee --append /etc/hosts > /dev/null

#Downloading the AppD Agent

cd /var/tmp/
mkdir appd-php
cd /var/tmp/appd-php

#Unzip the AppD Agent

tar -xvjf $1

cd appdynamics-php-agent
chmod 777 logs/
tiername=$4"_"$5
sudo ./install.sh -s -a=customer1@$appd_access_key  $2 443 $3 $tiername $6

# Restart apache httpd

sudo service httpd restart

# Clean up the temporary file and the agent package file

rm -rf /tmp/appd-php/downloadagent.done
rm -rf /tmp/appd-php/appdynamics-php-agent-x64-linux-4.3.5.0.tar.bz2

agentSendLogMessage "Installing AppDynamics Agent...done"
