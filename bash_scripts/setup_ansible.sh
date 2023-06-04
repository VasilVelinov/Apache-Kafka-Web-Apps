#!/bin/bash

echo "*Install ansible-core"
apt-get update
apt-get install -y sshpass
apt-get install -y ansible
ansible-galaxy collection install -p /usr/share/ansible/collections ansible.posix
ansible-galaxy collection install -p /usr/share/ansible/collections community.general

echo "*Prepare infrastructure ansible"
cd /vagrant/ansible/

echo "*Run ansible"
ansible-playbook servers.yml