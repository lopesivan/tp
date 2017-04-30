#!/bin/bash
#
#sudo apt install libgtk2.0-0:i386 libnss3-1d:i386

export PATH=$PATH:/opt/adobe-air-sdk/bin:/opt/adobe-air-sdk/lib
adl -nodebug /opt/bm/META-INF/AIR/application.xml /opt/bm/ "$@"
