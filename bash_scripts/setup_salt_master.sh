#!/bin/bash

echo "*Get bootstrap script for Salt"
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com

echo "*Install Latest Version of Salt"
sh bootstrap-salt.sh -M -N -X -P stable 3006.0 

echo "*Adjust Firewall"
systemctl disable --now firewalld

echo "* Start Salt Service"
systemctl enable --now salt-master

echo "*Accept all unauthorized keys"
sleep 30

# List unaccepted keys
unaccepted_keys=$(sudo salt-key -L unaccepted --out=raw | awk '{print $2}' | tr '\n' ',' | sed 's/,$//')

# Accept all unaccepted keys
if [ -n "$unaccepted_keys" ]; then
    sudo salt-key -A -y
fi

echo "*Configure salt master file"
sed -i '688s/[# ]//' /etc/salt/master
sed -i '689s/[# ]//' /etc/salt/master
sed -i '690s/[# ]//' /etc/salt/master
sed -i '688s/ //' /etc/salt/master

echo "*Copy SLS files for server machine"
mkdir /srv/salt || true
cp -v -R /vagrant/salt/* /srv/salt

echo "*Run Salt state docker file."
cd /srv/salt/
sleep 10
salt '*' state.apply docker

echo "*Run Salt state terraform file."
cd /srv/salt/
sleep 10
salt '*' state.apply terraform
