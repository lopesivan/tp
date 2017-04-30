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
# gimp.unsharp-mask.sh: .

# $Id:$
# Unite technology.
#      Author: Ivan carlos da Silva Lopes
#        Mail: lopesivan (dot) ufrj (at) gmail (dot) com
#        Site: http://www.unite.com.br
#       Phone: +55 21 8183 4933
#    Language: Shell Script
#        File: gimp.unsharp-mask.sh
#        Date: Mon 04 Mar 2013 12:02:03 PM BRT
# Description:
#
#

# ----------------------------------------------------------------------------
[ "$1" ] || ECHO=echo

$ECHO $0 "\"*.xcf\" 5.0 0.5 0"
$ECHO gimp -ibdf \
"(unsharp-mask RUN-NONINTERACTIVE $* )" \
-b '(gimp-quit 1)'

$ECHO $0 "\"*.xcf\" 5.0 0.5 0"

# ----------------------------------------------------------------------------
exit 0