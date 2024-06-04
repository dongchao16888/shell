#!/bin/bash

# aws debian linux os init
# by dongchao
# make666love@gmail.com

[ `whoami` -eq "root" ] && {
	echo "Error! you must be root to execute this script..."
	exit
}

echo "create backup directory..."
mkdir ~/backup 

echo "set allow using password to login in ..."
cp /etc/ssh/sshd_config ~/backup/
sed -ri 's/^#?(PasswordAuthentication)\s+(yes|no)/\1 yes/' /etc/ssh/sshd_config
echo 'Wise9Pkg!@' | passwd admin --stdin 


echo 'Wise9Pkg!@' | passwd --stdin develop

| chpasswd