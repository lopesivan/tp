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
# exemplo.sh: .

# $Id:$
# Federal University of Rio de Janeiro
#      Author: Ivan carlos da Silva Lopes
#        Mail: lopesivan (dot) ufrj (at) gmail (dot) com
#     License: gpl
#    Language: Shell Script
#        File: exemplo.sh
#        Date: Sat 01 Oct 2011 03:44:39 PM BRT
# Description:
#
#

#       +-----------+
#       |    cmd    |
#       +-----------+
#       | 0 | 1 | 2 |
#       +-^---v---v-+
#         |   |   |
#         |   |   |
#         |   |   + --- "2" is standard error
#         |   |
#         |   + --- "1" standard output
#         |
#        "0" is standard input
#
#      The standard streams have standard descriptors. "0" is standard input,
#      "1" standard output and "2" is standard error.

# ----------------------------------------------------------------------------
coproc CMD {
while read INPUT
do
    echo -=-=- $INPUT -=-=-
done
}

#echo Ivan Carlos Da Silva Lopes >&${CMD[1]}
cat file >&${CMD[1]}
read -u ${CMD[0]} OUTPUT

echo output: $OUTPUT
kill $CMD_PID

# ----------------------------------------------------------------------------
exit 0
