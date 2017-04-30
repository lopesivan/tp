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

X264_OPT="--demuxer y4m
          --crf 20
		  --preset slow
		  --profile baseline
		  --level 30
		  --vbv-bufsize 10000
		  --vbv-maxrate 10000
		  --threads auto
 "
# ----------------------------------------------------------------------------

#	-sws 9 -vf dsize=1280:720:0,scale=0:0,expand=1280:720,dsize=1.7 \
mplayer -nosound   \
	    -benchmark \
		-vo yuv4mpeg:file=>(x264 $X264_OPT --bitrate $1 --output $2 - 2>x264.log) $3

# ----------------------------------------------------------------------------
exit 0
