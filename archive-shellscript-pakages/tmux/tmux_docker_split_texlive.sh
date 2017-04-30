#!/usr/bin/env bash

    home=/home/lion
work_dir=${home}/${PWD//*\//}
   image=`whoami`/chef-solo-texlive

   host_texlive=${HOME}/Dropbox/texlive
virtual_texlive=/usr/local/texlive

tmux split-window -c "#{pane_current_path}"
tmux send-keys -t $(tmux display-message -p '#S') \
"docker run -ti --rm   \
  -v ${host_texlive}:${virtual_texlive} \
  -v `pwd`:${work_dir} \
  -w ${work_dir}       \
  --name=lion-texlive  \
  ${image}             \
  /bin/sh -c 'su lion; /bin/bash'" C-m

exit 0
