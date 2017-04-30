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
# mkrmemu.sh: `< =Short Description= >`.

# $Id:$
# AppTech’s LiveCam technology.
#      Author: Ivan carlos da Silva Lopes
#        Mail: lopesivan (dot) ufrj (at) gmail (dot) com
#        Site: http://www.apptechcorp.com
#       Phone: +1 561 801 7985
#    Language: Shell Script
#        File: mkrmemu.sh
#        Date: Mon 13 Feb 2012 12:07:02 AM BRST
# Description:
#
#

# ----------------------------------------------------------------------------

yad --form --title='Create/Delete Android Emulator'
	--field='android-3':BTN "@ls"  \
#    --field='android-4':BTN "@ls"  \
#    --field='android-7':BTN "@ls"  \
#    --field='android-8':BTN "@ls"  \
#    --field='android-10':BTN "@ls" \
#    --field='android-11':BTN "@ls" \
#    --field='android-12':BTN "@ls" \
#    --field='android-13':BTN "@ls" \
#    --field='android-14':BTN "@ls" \
#    --field='android-15':BTN "@ls" \
#    --field='LGE:Real3D Add-On:8':BTN "@ ls" \
#    --field='Google Inc.:Google APIs:8':BTN "@ ls"  \
#    --field='Google Inc.:Google APIs:10':BTN "@ ls" \
#    --field='Google Inc.:Google APIs:11':BTN "@ ls" \
#    --field='Google Inc.:Google APIs:13':BTN "@ ls" \
#    --field='Google Inc.:Google APIs:14':BTN "@ ls" \
#    --field='Google Inc.:Google APIs:15':BTN "@ ls" \
#    --field='KYOCERA Corporation:DTS Add-On:8':BTN "@ ls" \
#    --field='Samsung Electronics Co., Ltd.:GALAXY Tab Addon:8':BTN "@ ls"

# ----------------------------------------------------------------------------
exit 0
