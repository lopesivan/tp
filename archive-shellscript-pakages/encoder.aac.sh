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
#        File: encoder.sh
#        Date: Wed 30 May 2012 02:15:29 PM BRT
# Description:
#
#

#if [ $# -ne 2 ]; then
#    echo Abort
#    echo N = $#
#    exit 1
#fi

NEROAACENC_OPT="-ignorelength -lc -q 0.6"
# ----------------------------------------------------------------------------

mplayer -nocorrect-pts \
        -vo null       \
		-vc null       \
		-ao pcm:fast:file=>(neroAacEnc $NEROAACENC_OPT -if - -of $1 2>nero.log) $2

# ----------------------------------------------------------------------------
exit 0
