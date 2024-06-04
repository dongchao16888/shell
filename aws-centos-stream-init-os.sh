#!/bin/bash

adminPassword='ts2023Col8568!@'
wisePassword='dvAW9rGb06!@'
wwwDir='/var/www'
htmlDir='/var/www/html/blog.wisepkg.com'
currentDir=$(cd `dirname $0`; pwd)

# install docker
function install_docker(){
	yum install -y yum-utils device-mapper-persistent-data lvm2
	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	yum install docker-ce docker-ce-cli http://containerd.io
	# update docker group
	[  `grep -Eo "\bdocker\b" /etc/group | grep -v grep | wc -l` -lt 1 ] && {
		groupadd docker 
	}
	systemctl start docker
	systemctl status docker 
}

# install ssh key
function install_sshkey(){
	echo "install ssh keys >>>"
	ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa -q
}

function update_os(){
	echo "update system>>>"
	yum update -y 
}

# os update
function install_base_software(){
	echo "install softwares>>>"
	yum -y install lrzsz dos2unix vsftpd whois nodejs stunnel squid gcc gcc-c++ nginx git nodejs zip unzip 
	npm install -g hexo-cli
	npm install -g pm2
}

function close_selinux(){
	echo "close SELinux>>>"
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
}

function permit_password_login(){
	echo 'allow user login using password>>>'
	test ! -d ~/backup && mkdir ~/backup
	cp /etc/ssh/sshd_config ~/backup/
	sed -ri 's/^#?(PasswordAuthentication)\s+(yes|no)/\1 yes/' /etc/ssh/sshd_config
	systemctl restart sshd 
}

function create_admin(){
	# create admin group
	[ `grep -E "\badmin\b" /etc/group | grep -v grep | wc -l` -ne 1 ] && {
		echo '[info] - begin to create admin group >>>'
		groupadd admin 
		sleep 1 
	}
	[ `grep -E "\badmin\b" /etc/passwd | grep -v grep | wc -l` -ne 1 ] && {
		echo '[Info] - begin to create user admin >>>'
		useradd -g admin -d /home/admin -c "Admin User" admin
		sleep 1
		echo "set admin user's password >>>"
		echo $adminPassword | passwd --stdin admin 
		sleep 1 
	}
	# add admin group to sudoers.
	[ `grep admin /etc/group | grep -v grep | wc -l` -eq 1 ] && {
		echo 'add admin group to sudoers configure >>>'
		[ `grep admin /etc/sudoers | grep -v grep | wc -l` -lt 1 ] && {
			echo '%admin        ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers
		}
		sleep 1
	}
	# add admin user to docker group.
	gpasswd -a admin docker 
	newgrp docker 
}

function create_common(){
	# create common user group 
	[ `grep -E "\bcommon\b" /etc/group | grep -v grep | wc -l` -ne 1 ] && {
		echo '[info] - begin to create common group >>>'
		groupadd common 
		sleep 1 
	}

	[ `grep -E "\bwise\b" /etc/passwd | grep -v grep | wc -l` -ne 1 ] && {
		echo '[Info] - begin to create user wise >>>'
		useradd -g common -d /home/wise -c "Common APPlication User" wise
		sleep 1
		echo "set wise user's password >>>"
		echo $wisePassword | passwd --stdin wise 
		sleep 1 
	}

}

# ========================================================================================================
# ==============================================start=====================================================
# ========================================================================================================

[ `whoami` != "root" ] && {
	echo "you must be root to execute this script..."
	exit 0
}

[ ! -f "/etc/os-release" ] && [ ! -f "/etc/redhat-release" ] && {
	echo "[msg01] This script match Centos Stream 9, Please check os version...."
	exit 
}

[ -f "/etc/os-release" ] && {
	[ `cat /etc/os-release  | grep -v grep | grep "NAME=" | cut -d = -f 2` != "CentOS Stream" ] && {
		echo "[msg02] This script match Centos Stream 9, Please check os version...."
		exit 
	}
}

[ -f "/etc/redhat-release" ] && {
	[ `cat /etc/redhat-release | grep -v grep | grep CentOS` != "CentOS Stream release 9" ] && {
		echo "[msg03] This script match Centos Stream 9, Please check os version...."
		exit
	}
}


update_os()
sleep 1

close_selinux()
sleep 1

update_os()
sleep 1

install_sshkey()
sleep 1

permit_password_login()
sleep 1

create_admin()
sleep 1

create_common()
sleep 1

install_docker()
sleep 1 

# create application dirs.
[ ! -d $wwwDir ] && {
	mkdir -p $wwwDir
	chown wise:common -R $wwwDir
}

[ ! -d $htmlDir ] && {
	mkdir -p $htmlDir
	chown wise:common -R $htmlDir
}


echo "-----------------------------finish-----------------------------"
exit 
