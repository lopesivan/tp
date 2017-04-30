#!/usr/bin/env bash
#                      __ __       ___
#                     /\ \\ \    /'___`\
#                     \ \ \\ \  /\_\ /\ \
#                      \ \ \\ \_\/_/// /__
#                       \ \__ ,__\ // /_\ \
#                        \/_/\_\_//\______/
#                           \/_/  \/_____/
#                                         Algoritimos
#
#
#      Author: Ivan Lopes
#        Mail: ivan (at) 42algoritmos (dot) com (dot) br
#        Site: http://www.42algoritmos.com.br
#     License: gpl
#       Phone: +1 561 801 7985
#    Language: Shell Script
#        File: edit-last-file.sh
#        Date: Ter 14 Fev 2017 18:36:59 BRST
# Description:
#
# ----------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------

##############################################################################
##############################################################################
##############################################################################

# ----------------------------------------------------------------------------
# Run!
# edit last files

dir=~/.vim/w/md
file=$(
find ${dir}/ -type f -name ldoc.\*| sort|
while read doc; do
    head $doc |
    sed  -n '/^\=\{64\}/,/^\=\{64\}/p' |
    sed -e '1d' -e '$d'|
    sed.joinlines|
    sed 's/  */ /g'
done|
    cat -n |
    fzf-tmux -l 100% --multi --reverse --query="$1" --select-1 --exit-0
)

[ -n "$file" ] || exit 1

N=$(echo $file| sed 's/ .*//')
echo $N

let count=0

find ${dir}/ -type f -name ldoc.\*| sort |
while read doc; do
    let count++
    if [ $count -eq $N ]; then
        echo $doc
        break
    fi
done | xargs -Ifile vim -R -c'0' -c'map ? :qall!<CR>' -c'map <ESC> :qall!<CR>' -c'map q :qall!<CR>'  -c'colorscheme base16-cupcake' -c'Goyo' file
# done | xargs -Ifile vim -c'colorscheme base16-cupcake' -c'Goyo' file

# ----------------------------------------------------------------------------
exit 0
