#! /bin/bash
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
# batch-resize.sh: .

# $Id:$
# Unite technology.
#      Author: Ivan carlos da Silva Lopes
#        Mail: lopesivan (dot) ufrj (at) gmail (dot) com
#        Site: http://www.unite.com.br
#       Phone: +55 21 8183 4933
#    Language: Shell Script
#        File: batch-resize.sh
#        Date: Sun 03 Mar 2013 08:33:34 PM BRT
# Description:
#
#

# ----------------------------------------------------------------------------
[ "$1" ] || exit 1

if [ $__help__ == 1 ]; then
    echo
    echo "Usage: $(basename $0) file1.png [file2.png ...] W H"
    echo
    exit 1
fi
scm=batch-fibonacci

a=( $* )
echo a=${a[*]}
w=${a[-1]}
echo w=$w
h=${a[-2]}
echo h=$h

for i in $(seq 0 $((${#a[*]}-3))); do
	echo gimp -i -b "(${scm} \"${a[i]}\" $w $h)" -b "(gimp-quit 0)"
	#$ECHO gimp -i -b "(${scm} \"${a[i]}\" $w $h)" -b "(gimp-quit 0)"
done

# ----------------------------------------------------------------------------
exit 0
