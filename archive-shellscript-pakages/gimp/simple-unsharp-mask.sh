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
# simple-unsharp-mask.sh: .

# $Id:$
# Unite technology.
#      Author: Ivan carlos da Silva Lopes
#        Mail: lopesivan (dot) ufrj (at) gmail (dot) com
#        Site: http://www.unite.com.br
#       Phone: +55 21 8183 4933
#    Language: Shell Script
#        File: simple-unsharp-mask.sh
#        Date: Sun 03 Mar 2013 09:04:08 PM BRT
# Description:
#
#

# ----------------------------------------------------------------------------

if [ $__help__ -eq 1 ]; then
	#__help__ has value equal 1
	#__help__ ON

    echo
    echo "Usage: $(basename $0) file1.png [file2.png ...]"
    echo
    echo "  This script uses gimp to autocrop PNG files and"
    echo "  save them to PNG format.  You must have"
    echo "  crop-png.scm installed in your gimp "
    echo "  scripts directory."
    echo
    exit 1

fi

# foo.png 5.0 0.5 0
$ECHO gimp -i -b "(simple-unsharp-mask \"$1\" $2 $3 $4 )" -b "(gimp-quit 0)"
#                  |                     |    |  |  |
#                  scm                   |    |  |  `* 0    threshold
#                                        |    |  `* 0.5     amount
#                                        |    `* 5.0        radius
#                                        `* foo.png         filename
#

# ----------------------------------------------------------------------------
exit 0
