#!/bin/bash

# 安装配置squid/stunnel/nginx等基础软件
# by dongchao
# 2023-11-06

currentDir=$(cd `dirname $0`; pwd)

[ `whoami` != "root" ] && {
	echo "you must be root to execute this script..."
	exit 0
}

baseZipFile="./wisepkg.install.zip"
[ ! -e "$baseZipFile" ] && {
	echo "[Error] - baseInstallZipFile not exist..."
	exit 
}

unzip "$baseZipFile"


echo 'begin to install squid and stunnel...'
yum install nginx -y 
sleep 1 

echo 'begin to config softwares...'
[ ! -d "./nginxInstall" ] && {
	echo "[Error] -  ./nginxInstall not found, exit..."
	exit 
}

[ ! -f "./nginxInstall/nginx.conf" ] && {
	echo "[Error] - ./nginxInstall/nginx.conf not found, exit..."
	exit 
}

[ ! -d "./nginxInstall/conf.d" ] && {
	echo "[Error] - ./nginxInstall/conf.d not found, exit..."
	exit 
}


[ ! -d "./ssl" ] && {
	echo "[Error] - ./ssl not found, exit..."
	exit 
}

[ ! -f "/etc/nginx.conf" ] && {
	echo "[Error] - /etc/nginx/nginx.conf not found, exit..."
	exit 
}

[ ! -d "/etc/nginx/conf.d" ] && mkdir -p /etc/nginx/conf.d 

echo 'begin to copy nginx config files...'
mv /etc/nginx.conf /etc/nginx.conf.bak
cp ./nginxInstall/nginx.conf /etc/nginx/
cp ./nginxInstall/conf.d/. /etc/nginx/conf.d/
sleep 1 

echo 'create nginx log directory...'
[ ! -d "/var/log/nginx/blog.wisepkg.com" ] && mkdir -p /var/log/nginx/blog.wisepkg.com
[ ! -d "/var/log/nginx/download.wisepkg.com" ] && mkdir -p /var/log/nginx/download.wisepkg.com
[ ! -d "/var/log/nginx/gf.wisepkg.com" ] && mkdir -p /var/log/nginx/gf.wisepkg.com
[ ! -d "/var/log/nginx/qa.wisepkg.com" ] && mkdir -p /var/log/nginx/qa.wisepkg.com
[ ! -d "/var/log/nginx/doc.wisepkg.com" ] && mkdir -p /var/log/nginx/doc.wisepkg.com
sleep 1 

echo 'save ssl cerificate files...'
cp -avxf ./ssl /opt/

echo '[Info] - begin to start nginx process...'
systemctl start nginx 

exit 

