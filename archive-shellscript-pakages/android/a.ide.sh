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
# a.cad.sh: .

# $Id:$
# AppTech’s LiveCam technology.
#      Author: Ivan carlos da Silva Lopes
#        Mail: lopesivan (dot) ufrj (at) gmail (dot) com
#        Site: http://www.apptechcorp.com
#       Phone: +1 561 801 7985
#    Language: Shell Script
#        File: a.cad.sh
#        Date: Mon 13 Feb 2012 12:16:58 AM BRST
# Description:
#
#

# ----------------------------------------------------------------------------
yad --form --width 300 --columns=5  --title "Dicas-l de Rubens Queiroz" \
	--image bg_logo.png \
	--text "<big>Informe sua <b>preferência sobre frutas</b></big>" \
	--field " android-3                          :CHK" \
	--field " android-4                          :CHK" \
	--field " android-7                          :CHK" \
	--field " android-8                          :CHK" \
	--field " Google Inc. A.8                    :CHK" \
	--field " KYOCERA Corporation A.8            :CHK" \
	--field " LGE A.8                            :CHK" \
	--field " Samsung Electronics Co., Ltd. A.8  :CHK" \
	--field " android-10                         :CHK" \
	--field " Google Inc. A.10                   :CHK" \
	--field " android-11                         :CHK" \
	--field " Google Inc. A.11                   :CHK" \
	--field " android-12                         :CHK" \
	--field " android-13                         :CHK" \
	--field " Google Inc. A.13                   :CHK" \
	--field " android-14                         :CHK" \
	--field " Google Inc. A.14                   :CHK" \
	--field " android-15                         :CHK" \
	--field " Google Inc. A.15                   :CHK" \

# ----------------------------------------------------------------------------
exit 0

