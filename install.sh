#! /bin/bash

      pakage_dir=`pwd`
local_pakage_dir=`pwd`/archive-shellscript-pakages
  bin_pakage_dir=`pwd`/bin-shellscript-pakages
     output_file=${HOME}/developer/bash-it/custom/tp.bash

table()
{
cat << __EOF_TABLE__
#-----------------------+---------------------------------------------------
# original script       |  link name
#-----------------------+---------------------------------------------------

bm.sh                   | balsamiqmockups
g_opt.sh                | g_opt
hw-1.sh                 | hw
tp.sh                   | tp
g_tp.sh                 | g_tp
neroAacDec              | neroAacDec
neroAacEnc              | neroAacEnc
neroAacTag              | neroAacTag
__EOF_TABLE__
}

do_links()
{
table | while read __LINE__; do

  [ "$__LINE__" ] || continue

  expr "$__LINE__" : '#' > /dev/null

  if [ $? -eq 0 ]; then
    continue
    # is a comment
  fi

  echo $__LINE__  | \
    sed 's/|//' | {
      read first rest ;
      echo ln -s " ${local_pakage_dir}/$first ${bin_pakage_dir}/$rest";
    } | sh

done
}

##############################################################################

main()
{
  test -e .log && ./uninstall.sh

  id=$$
  id=$(uuidgen)
  mkdir -p ${bin_pakage_dir}
  do_links

  cat << EOF > $output_file
#!/usr/bin/env bash
#
# This is an example file. Don't use this for your custom scripts. Instead, create another file within the
# custom directory.

EOF
  echo export SHELLSCRIPT_TEMPLATE_PKG=${pakage_dir}/template >> $output_file
  echo export SHELLSCRIPT_CTEMPLATE=${pakage_dir}/ctemplate   >> $output_file
  echo export SHELLSCRIPT_PKG=${bin_pakage_dir}               >> $output_file
  echo export PATH=${bin_pakage_dir}:\$PATH                   >> $output_file
  echo export SHELLSCRIPT_PAKAGES=${local_pakage_dir}         >> $output_file
  echo '
mvToTemplate ()
{
  cp *.templatefile $SHELLSCRIPT_TEMPLATE_PKG
}
goTemplate ()
{
  cd  $SHELLSCRIPT_TEMPLATE_PKG
}
' >> $output_file

cat << EOF >> $output_file
_tp()
{
  local cur prev opts
  COMPREPLY=()
  cur="\${COMP_WORDS[COMP_CWORD]}"
  prev="\${COMP_WORDS[COMP_CWORD-1]}"
  # n=\$(( \$(tp list --| wc -l) -1 ))
  opts=\`tp list --| awk '{print $2}'| sed -e '$d' | sed -e :a -e '$!N; # s/\n/ /; ta'\`

  if [[ \${cur} == --* ]] ; then
    COMPREPLY=( \$(compgen -W "\${opts}" -- \${cur}) )
    return 0
  fi
}
complete -F _tp tp
EOF
}

main && exit 0
