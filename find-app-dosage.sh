#!/bin/bash

# 获取edged应用进程cpu、内存等使用率；

while true
do
	ps -aux | grep edged | grep -v grep | while read line
	do
		cpu=`echo $line | awk '{print $3}'`
		mem=`echo $line | awk '{print $4}'`
		ram=`echo $line | awk '{print $6}'`
		echo "cpu: $cpu, mem: $mem, ram: $ram"
		curl -i -XPOST http://127.0.0.1:8086/write?db=dosage --data-binary "cpu,app=edged value=$cpu"
		curl -i -XPOST http://127.0.0.1:8086/write?db=dosage --data-binary "mem,app=edged value=$mem"
		curl -i -XPOST http://127.0.0.1:8086/write?db=dosage --data-binary "ram,app=edged value=$ram"
	done
	# sleep 1 
done