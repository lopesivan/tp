#! /bin/bash

echo $[`cat /proc/net/dev | grep eth0 | sed s/eth0://g | tr -s " " | awk '{print $1;}'` % 2147483648 ]
echo $[`cat /proc/net/dev | grep eth0 | sed s/eth0://g | tr -s " " | awk '{print $9;}'` % 2147483648 ]
uptime|sed -e 's/.*up \(.*\),.*[0-9]* user.*/\1/'
hostname
exit 0
