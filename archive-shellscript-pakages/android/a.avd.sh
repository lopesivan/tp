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
# a.avd.sh:

# $Id:$
# AppTech’s LiveCam technology.
#      Author: Ivan carlos da Silva Lopes
#        Mail: lopesivan (dot) ufrj (at) gmail (dot) com
#        Site: http://www.apptechcorp.com
#       Phone: +1 561 801 7985
#    Language: Shell Script
#        File: a.avd.sh
#        Date: Mon 13 Feb 2012 03:40:59 AM BRST
# Description:
#
#

# ----------------------------------------------------------------------------
PROGRAM_NAME=$(echo `basename $0`)
OPT_EMU="-audio oss"
OPT_EMU="-audio alsa -debug audio"

case $PROGRAM_NAME in
	'a.ls'    )
		android list avd
	;;
	'a.15')
		emulator $OPT_EMU -avd a15
	;;
	'a.21')
		emulator $OPT_EMU -avd a21
	;;
	'a.22')
		emulator $OPT_EMU -avd a22
	;;
	'a.23')
		emulator $OPT_EMU -avd a23
	;;
	'a.40')
		emulator $OPT_EMU -avd a403
	;;
esac

# ----------------------------------------------------------------------------
exit 0
