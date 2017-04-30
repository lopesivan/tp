#!/usr/bin/env bash

dir=~/.vim

_file=$(
    find $dir/snippets/ $dir/UltiSnips/ $dir/my-snippets/ -type f -name \*.snippets |
    rev | sort | rev |
    fzf-tmux -l 100% --multi --reverse --query="$1" --select-1 --exit-0
)

[ -n "$_file" ] && vim -c 'Goyo' $_file
# [ -n "$_file" ] && vim -c 'Goyo' -c 'set relativenumber' $_file

exit 0
