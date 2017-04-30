#!/usr/bin/env bash

dir=~/.vim

_file=$(
    find $dir/settings/ -type f -name \*.local |
        fzf-tmux -l 100% --multi --reverse --query="$1" --select-1 --exit-0
)

[ -n "$_file" ] && vim -c 'Goyo' $_file

exit 0
