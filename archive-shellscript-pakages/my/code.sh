#!/usr/bin/env bash

dir=/home/ivan/developer/vim/vim/w/data
_extension=$(
    ls $dir/example | sed 's/^.*\.//' | sort | uniq |
        fzf-tmux -l 20% --multi --query="$1" --select-1 --exit-0
)

[ -n "$_extension file" ] &&
    _file=$(
        ls $dir/example/*.${_extension} |
            fzf-tmux -l 100% --multi --reverse --query="$1" --select-1 --exit-0
    )

[ -n "$_file" ] && vim -R -c'0' -c'map ? :qall!<CR>' -c'map q :qall!<CR>' -c'map <ESC> :qall!<CR>' -c'colorscheme base16-cupcake' -c'Goyo' $_file

exit 0
