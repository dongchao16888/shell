#!/bin/bash

# 安装配置squid/stunnel/nginx等基础软件
# by dongchao
# 2023-11-06

currentDir=$(cd `dirname $0`; pwd)

[ `whoami` != "root" ] && {
	echo "you must be root to execute this script..."
	exit 0
}

echo 'begin to config softwares...'
[ ! -d "./config" ] && {
	echo "[Error] -  ./config not found, exit..."
	exit 
}

[ ! -f "./config/nginx.conf" ] && {
	echo "[Error] - ./config/nginx.conf not found, exit..."
	exit 
}

[ ! -d "./config/conf.d" ] && {
	echo "[Error] - ./config/conf.d not found, exit..."
	exit 
}

[ ! -d "./ssl" ] && {
	echo "[Error] - ./ssl not found, exit..."
	exit 
}

[ ! -f "/etc/nginx/nginx.conf" ] && {
	echo "[Error] - /etc/nginx/nginx.conf not found, exit..."
	exit 
}

[ ! -d "/etc/nginx/conf.d" ] && mkdir -p /etc/nginx/conf.d 
[ ! -d "/var/www/html/static/images" ] && mkdir -p /var/www/html/static/images

echo 'begin to copy nginx config files...'
mv /etc/nginx/nginx.conf /etc/nginx.conf.bak
cp ./config/nginx.conf /etc/nginx/
cp -avxf ./config/conf.d/. /etc/nginx/conf.d/
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
systemctl restart nginx 
systemctl status nginx
echo '-----------------------------finish------------------------------'
exit 

