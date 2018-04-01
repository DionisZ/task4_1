#!/bin/bash

if [ "$USER" != "root" ]; then
	echo "The user $USER  doesn't have root access"
	exit 1
fi

workdir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
exec 1> $workdir/task4_1.out


echo '--- Hardware ---'
cpu=$(cat /proc/cpuinfo | grep 'model name' | uniq | awk -F': ' '{print$2}')
ram=$(cat /proc/meminfo | grep MemTotal | awk -F': *' '{print $2}')
board=$(dmesg -H | grep DMI: | awk -F': ' '{print$2}' | sed 's/,.*//g')
ssn=$(sudo dmidecode -t system | grep 'Serial Number' | awk -F': ' '{print$2}')

echo "CPU: $cpu"
echo "RAM: $ram"
echo "Motherboard: $board"
if [ -z "$ssn" ]; then
  echo "Unknown"
else
  echo "System Serial Number: $ssn"
fi


echo '--- System ---'
dist=$(lsb_release -d | awk '{print $2, $3, $4}')
kernV=$(uname -r)
installD=$(sudo ls -alct /|tail -1| awk '{print $6, $7, $8}')
uptime=$(uptime -p | awk -F',' '{print$1}')
procRun=$(ps -ela | wc -l)
users=$(who | wc -l)

echo "OS Distribution: $dist"
echo "Kernel version: $kernV"
echo "Installation date: $installD"
echo "Hostname: $HOSTNAME"
echo "Uptime: $uptime"
echo "Processes running: $procRun"
echo "Users logged in: $users"

echo '--- Network ---'

for i in $(ip a list | awk -F:' ' '{print $2}' | sed '/^$/d'); do
  if [ -z "$(ip -4 a s "$i" | grep inet | sed 's/^ *//g' | awk -F' ' '{print $2}')" ]; then
    echo "$i: -"
  else
    echo -n "${i}: " && echo `ip -4 a s "$i" | grep inet | sed 's/^ *//g' | awk -F' ' '{print $2}'`
  fi
done





