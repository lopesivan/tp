#!/bin/bash
# ----------------------------------------------------------------------------
__debug__=0; __help__=0
__usage__=0
__clean__=0
# ----------------------------------------------------------------------------
[ "$1" = '--gui'   ] && { __gui__=1; shift;   }
[ "$1" = '-h'      ] && { __help__=1; shift;  }
[ "$1" = '--help'  ] && { __help__=1; shift;  }
[ "$1" = '-d'      ] && { __debug__=1; ECHO=echo;shift; }
[ "$1" = '--debug' ] && { __debug__=1; ECHO=echo;shift; }
[ "$1" = '--usage' ] && { __usage__=1; shift; }
[ "$1" = '--clean' ] && { __clean__=1; shift; }
# ----------------------------------------------------------------------------

##############################################################################
##############################################################################
##############################################################################

# vi:set nu nowrap:

# $Id:$
# AppTech’s LiveCam technology.
#      Author: Ivan carlos da Silva Lopes
#        Mail: lopesivan (dot) ufrj (at) gmail (dot) com
#        Site: http://www.apptechcorp.com
#       Phone: +1 561 801 7985
#    Language: Shell Script
#        File: do.sh
#        Date: Sun 01 Apr 2012 11:24:07 PM BRT
# Description:
#
#

# ----------------------------------------------------------------------------

echo copy icons ...
#cp tools/android_icons/size_36x36/icon.png res/drawable-ldpi/
cp tools/android_icons/size_48x48/icon.png res/drawable-ldpi/
cp tools/android_icons/size_72x72/icon.png res/drawable-mdpi/
cp tools/android_icons/size_96x96/icon.png res/drawable-hdpi/

# ----------------------------------------------------------------------------
exit 0
