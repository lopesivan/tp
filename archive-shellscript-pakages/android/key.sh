#!/bin/bash
##############################################################################
##############################################################################
##############################################################################

# vi:set nu nowrap:
# key.sh: .

# $Id:$
# AppTech’s LiveCam technology.
#      Author: Ivan carlos da Silva Lopes
#        Mail: lopesivan (dot) ufrj (at) gmail (dot) com
#        Site: http://www.apptechcorp.com
#       Phone: +1 561 801 7985
#    Language: Shell Script
#        File: key.sh
#        Date: Thu 12 Jan 2012 05:57:00 PM BRST
# Description:
#
#

# ----------------------------------------------------------------------------
keystore=apptechcorp.com.keystore
   alias=apptechcorp.com
validity=10000

keytool \
	-genkey -v          \
	-keystore $keystore \
	-alias $alias       \
	-keyalg RSA         \
	-keysize 2048       \
	-validity $validity

cat << EOF > ant.properties
# This file is used to override default values used by the Ant build system.
#
# This file must be checked in Version Control Systems, as it is
# integral to the build system of your project.

# This file is only used by the Ant script.

# You can use this to override default values such as
#  'source.dir' for the location of your java source folder and
#  'out.dir' for the location of your output folder.

# You can also use it define how the release builds are signed by declaring
# the following properties:
#  'key.store' for the location of your keystore and
#  'key.alias' for the name of the key to use.
# The password will be asked during the build when you use the 'release' target.

key.store=./$keystore
key.alias=$alias
EOF

# ----------------------------------------------------------------------------
exit 0
