$ for f in /sys/class/net/*; do echo -e "$(basename $f)\t$(cat $f/address)"; done
docker0	56:84:7a:fe:97:99
eth0	80:ee:73:11:0e:13
lo	00:00:00:00:00:00
lxcbr0	96:be:f6:8c:b9:8c
virbr0	c2:3e:87:ad:e7:20
wlan0	00:02:72:9b:ab:90
