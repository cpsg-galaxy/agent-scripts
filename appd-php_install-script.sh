#!/bin/bash

#Reference userenv
. /usr/local/osmosix/service/utils/agent_util.sh
source /usr/local/osmosix/etc/userenv

agentSendLogMessage "Installing AppDynamics Agent..."

# Setting the script to exit immediately on any command failure
set -e
set -o pipefail

#Set variables
tiername=$5"_"$6

#Add Host file entry for appd-controller
sudo echo "$2	appd-controller" | sudo tee --append /etc/hosts > /dev/null

#Create installation directory and move agent
mkdir -p /opt/appdynamics/appd-php
cd /opt/appdynamics/appd-php
mv /tmp/$1 .

#Unzip the AppD Agent
tar -xvjf $1
cd appdynamics-php-agent-linux_x64

#Change permissions for the PHP and logs folders
chmod -R 777 /appd-php
chmod -R 777 /appd-php/logs

#Install the appd-php agent
./install.sh -a=$3  $2 8090 $4 $tiername $7

# Restart apache httpd
sudo service httpd restart

# Clean up the agent package file
rm -rf $1

agentSendLogMessage "Installing AppDynamics Agent...done"
