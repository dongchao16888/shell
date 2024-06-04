#!/bin/bash

# this script is used to init aws cloud host and os is opensuse.
# by dongchao
# make666love@gmail.com


echo "check current execute user>>>"
[ `whoami` != "root" ] && {
	echo "Error! you must be root to execute this script..."
	exit
}
sleep 1 

echo "add develop user..."
groupadd deploy
useradd -g deploy -m -d /home/develop develop 
echo 'Wise9Pkg!@' | passwd --stdin develop


func install_docker(){
	zypper install docker docker-compose docker-compose-switch
}

echo "init work for develop>>>"
mkdir ~/home/develop/shell
mkdir ~/home/develop/python3
mkdir ~/home/develop/backup
mkdir ~/home/develop/stunnel
mkdir ~/home/develop/goApp
mkdir ~/home/develop/download

chown develop:deploy -R /home/develop
chmod 700 /home/develop

echo "create pem for stunnel>>>"
openssl req -new -x509 -days 365 -nodes -out stunnel.pem -keyout ~/stunnel/stunnel.pem
sleep 1

echo "create ssh-key>>>"
ssh-keygen
sleep 1 

echo "allow user login using password>>>"
cp /etc/ssh/sshd_config ~/backup/
sed -ri 's/^#?(PasswordAuthentication)\s+(yes|no)/\1 yes/' /etc/ssh/sshd_config
systemctl restart sshd 

echo "begin to update system>>>"
zypper update 
sleep 1

echo "install base software>>>"
zypper install lrzsz dos2unix vsftpd whois  net-tools-deprecated -y
sleep 1 

echo "begin to install nodejs"
zypper install nodejs 
sleep 1 

echo "install hexo>>>"
npm install -g hexo-cli
sleep 1

echo "install pm2>>>"
npm install pm2 -g 
sleep 1 

echo "install stunnel>>>"
zypper install stunnel
[ -f /etc/stunnel/stunnel.conf ] && {
cat >/etc/stunnel/stunnel.conf<<EOF
[squid-proxy]
cert=/etc/stunnel/stunnel.pem
accept=3129
connect = localhost:3128
EOF
}
cp ~/stunnel/stunnel.pem /etc/stunnel/
systemctl start stunnel
systemctl enable stunnel 
sleep 1 

echo "install squid>>>"
zypper install squid
systemctl start squid
systemctl enable squid 
sleep 1

echo "install nginx>>>"
zypper install nginx
systemctl start nginx
systemctl enable nginx 
sleep 1


echo "start docker daemon>>>"
systemctl start docker
systemctl enable docker 
docker pull mysql
docker pull influxdb:1.8 

