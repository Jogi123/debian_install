#!/bin/bash

# update system
apt update
apt upgrade

# enable firewall and set rules
apt install ufw
ufw default allow outgoing
ufw default deny incoming
ufw enable
echo "Do you want to open port 22(ssh) [y/n]?"
read wish
if [ $wish = "y" ]
then
  # install openssh and open port 22
  ufw limit 22
  apt install openssh-server
  systemctl enable openssh-server
  systemctl start openssh-server
  
  # secure ssh (set root login and password authentication to no
  sed -e "s/#PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
  sed -e "s/#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
fi

# create keys and copy them to a server
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
