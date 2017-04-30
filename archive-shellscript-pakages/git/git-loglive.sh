#!/bin/bash

watch --color "git --no-pager log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s' --abbrev-commit --date=relative --all -20"

exit 0
