#!/bin/bash
# ----------------------------------------------------------------------------
source key.txt

##############################################################################
##############################################################################
##############################################################################

# vi:set nu nowrap:
# signing.sh: Signing Your Applications.

# $Id:$
# AppTech’s LiveCam technology.
#      Author: Ivan carlos da Silva Lopes
#        Mail: lopesivan (dot) ufrj (at) gmail (dot) com
#        Site: http://www.apptechcorp.com
#       Phone: +1 561 801 7985
#    Language: Shell Script
#        File: signing.sh
#        Date: Fri 13 Jan 2012 03:00:08 PM BRST
# Description: The Android system requires that all installed applications be
# digitally signed with a certificate whose private key is held by the
# application's developer. The Android system uses the certificate as a means
# of identifying the author of an application and establishing trust
# relationships between applications. The certificate is not used to control
# which applications the user can install. The certificate does not need to be
# signed by a certificate authority: it is perfectly allowable, and typical,
# for Android applications to use self-signed certificates.
#
# ----------------------------------------------------------------------------

keytool -list  \
-alias $alias  \
-keystore $PWD/$keystore \
-storepass $storepass    \
-keypass $keypass
# ----------------------------------------------------------------------------
exit 0
