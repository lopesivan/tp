#!/usr/bin/env bash

    home=/home/lion
work_dir=${home}/${PWD//*\//}
   image=texlive
    path=/bin:/usr/local/bin:/usr/bin:/usr/local/bin:/usr/local/texlive/2014/bin/x86_64-linux
#split-window -c "#{pane_current_path}"
tmux new-window -n ${work_dir} -c "#{pane_current_path}"
tmux send-keys -t $(tmux display-message -p '#S') \
"docker run -ti --rm   \
  -v `pwd`:${work_dir} \
  -w ${work_dir}       \
  --name=lion-texlive  \
  -e PATH=${path}      \
  ${image}             \
  /bin/sh -c 'su lion; /bin/bash'" C-m

exit 0
