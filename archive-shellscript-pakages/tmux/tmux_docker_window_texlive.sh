#!/usr/bin/env bash

home=/home
work_dir=${home}/${PWD//*\//}
image=`whoami`/chef-solo-texlive

   host_texlive=${HOME}/Dropbox/texlive
virtual_texlive=/usr/local/texlive

tmux new-window -n ${work_dir} -c "#{pane_current_path}"
tmux send-keys -t $(tmux display-message -p '#S') \
"docker run -ti --rm   \
  -v ${host_texlive}:${virtual_texlive} \
  -v `pwd`:${work_dir} \
  -w ${work_dir}       \
  --name=texlive       \
  ${image}             \
  /bin/sh -c '/bin/bash'" C-m

exit 0
