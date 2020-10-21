#!/bin/bash

apt update
apt upgrade

apt install ufw
ufw default allow outgoing
ufw default deny incoming
ufw enable

echo "Do you want to open port 22(ssh) [y/n]?"
read wish

if [ $wish = "y" ]
then
  ufw limit 22
fi

apt install openssh-server
systemctl enable openssh-server
systemctl start openssh-server
