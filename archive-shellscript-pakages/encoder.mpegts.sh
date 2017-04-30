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
FFMPEG_OPT="-f mpegts
			-acodec libmp3lame
			-ar 32000
			-ab 48k
			-s 1280x720
            -vcodec libx264
			-b 200k
			-flags +loop+mv4
			-cmp 256
			-partitions +parti4x4+partp8x8+partb8x8
			-subq 7
			-trellis 1
			-refs 5
			-coder 0
			-me_range 16
            -keyint_min 25
			-sc_threshold 40
			-i_qfactor 0.71
			-bt      $2
			-maxrate $2
            -bufsize $2
			-rc_eq 'blurCplx^(1-qComp)'
			-qcomp 0.6
			-qmin 10
			-qmax 51
			-qdiff 4
			-level 30
			-aspect 16:9
			-r 15
			-g 45
			-async 2
"

# ----------------------------------------------------------------------------
ffmpeg -er 4 -i $1 $FFMPEG_OPT $3
# ----------------------------------------------------------------------------
exit 0
