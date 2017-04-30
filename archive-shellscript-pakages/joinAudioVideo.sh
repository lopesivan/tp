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
# joinAudioVideo.sh: .

# $Id:$
# AppTech’s LiveCam technology.
#      Author: Ivan carlos da Silva Lopes
#        Mail: lopesivan (dot) ufrj (at) gmail (dot) com
#        Site: http://www.apptechcorp.com
#       Phone: +1 561 801 7985
#    Language: Shell Script
#        File: joinAudioVideo.sh
#        Date: Sat 30 Jun 2012 12:19:13 AM BRT
# Description:
#
#
if [ $# -ne 3 ]; then
	echo Abort
	echo N = $#
	exit 1
fi

# ----------------------------------------------------------------------------
FFMPEG=avconv
FFMPEG_OPTS="-acodec copy -vcodec copy"

 audio=$1
 video=$2
output=$3

$FFMPEG -i $audio -i $video $FFMPEG_OPTS -y $output

# ----------------------------------------------------------------------------
exit 0
