#!/usr/bin/env bash

    home=/home/lion
work_dir=/data
   image=`whoami`/sharelatex

   host_texlive=${HOME}/Dropbox/texlive
virtual_texlive=/usr/local/texlive
host_data=/workspace/sharelatex

mkdir -p $host_data

tmux new-window -n "sharelatex-log" -c "#{pane_current_path}"
tmux send-keys -t $(tmux display-message -p '#S') \
"docker run -ti --rm \
  -v ${host_texlive}:${virtual_texlive} \
  -v ${host_data}:${work_dir}           \
  --name=sharelatex                     \
  -p 3000:80                            \
  -w ${work_dir}                        \
  ${image}                              \
  /bin/sh -c '/bin/bash'" C-m

exit 0
