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
ssh-keygen

echo "Do you want to copy your key to remote server? [y/n]"
read copy
if [ $copy = "y" ]
then
  echo "Type in the server address you want to copy your key to: "
  read address
  echo "Type in the username for $address: "
  read username
  cat ~/.ssh/id_rsa.pub | ssh $username@$address 'cat >> .ssh/authorized_keys && echo "Key copied"'
fi