#!/bin/bash

# 存放经常会用用到的函数。


# 检测目录是否存在
function check_dir_exist{
	[ -n "$1" ] && {
		[ "`ls -A $1`" == "" ] && echo "Y" || echo "N"
	}
}