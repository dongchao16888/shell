#!/bin/bash

# 安装配置squid/stunnel代理软件
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

[ ! -f "./config/squid.conf" ] && {
	echo "[Error] - ./config/squid.conf not found, exit..."
	exit 
}

[ ! -f "./config/stunnel.conf" ] && {
	echo "[Error] - ./config/stunnel.conf not found, exit..."
	exit 
}

[ ! -f "./config/stunnel.pem" ] && {
	echo "[Error] - ./config/stunnel.pem not found, exit..."
	exit 
}

echo 'beigin to install squid and stunnel...'
yum install squid stunnel -y 
sleep 1

echo 'copy squid config files...'
[ -f /etc/squid/squid.conf ] && {
	mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
}

cp ./config/squid.conf /etc/squid/
sleep 1 

echo 'begin to start squid process...'
systemctl start squid
systemctl status squid
sleep 1 

echo 'copy stunnel config files...'
[ -f /etc/stunnel/stunnel.conf ] && mv /etc/stunnel/stunnel.conf /etc/stunnel/stunnel.conf.bak
[ ! -d /etc/stunnel/conf.d ] && mkdir /etc/stunnel/conf.d 
cp ./config/stunnel.conf /etc/stunnel/
cp ./config/stunnel.pem /etc/stunnel/
sleep 1 

echo 'add running mode user for stunnel...'
useadd -M -s /sbin/nologin stunnel
sleep 1 

echo 'begin to start stunnel process...'
systemctl start stunnel
systemctl status stunnel

echo '[Info] - now stunnel is listening on port 3129'
echo '-----------------------------finish------------------------------'
exit 

