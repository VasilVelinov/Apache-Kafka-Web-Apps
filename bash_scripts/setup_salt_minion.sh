#!/bin/bash

echo "*Get bootstrap script for Salt"
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com

echo "*Install Latest Version of Salt"
sh bootstrap-salt.sh -P stable 3006.0

echo "*Install Pip and docker-py"
dnf install -y python-pip
pip install docker-py

echo "*Change config file of Salt Minion"
sed -i '16s/.*/master: containers/' /etc/salt/minion

echo "*Restart Salt Minion"
systemctl restart salt-minion
