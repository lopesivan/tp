#! /bin/bash

cat /proc/net/dev | grep eth0 | cut -d : -f 2 | awk '{ print $1; print $9 }'
exit 0
