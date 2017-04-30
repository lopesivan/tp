#!/usr/bin/env bash
GIT=${HOME}/git
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
#       Author: Ivan carlos da Silva Lopes
#         Mail: ivanlopes (at) 42algoritimos (dot) com (dot) br
#      License: gpl
#        Site: http://www.42algoritmos.com.br
#       Phone: +1 561 801 7985
#    Language: Shell Script
#        File: new.sh
#        Date: Thu 17 Oct 2013 06:10:01 PM BRT
# Description:
[ "$1" ] || { echo Você não informou o nome do repositório; exit 1;}
# ----------------------------------------------------------------------------
original_dir=$PWD
dir=${1}
mkdir -p $GIT/${dir}.git && cd $_
git init --bare
echo
echo clone:
echo ================================
echo git clone file://${HOME}/git/${dir}.git
echo ================================
echo

cd $original_dir
git clone file://${HOME}/git/${dir}.git
#git remote add origin file://${HOME}/git/${dir}.git

cd ${dir}
git flow init -d

# 1
git flow feature start f-01
  echo "feature 1" >>features.txt
  git add .
  git commit -m "primeira feature"
git flow feature finish f-01

# 2
git flow feature start f-02
  echo "feature 2" >>features.txt
  cp ${GIT}/*.sh .
  git add .
  git commit -m "segunda feature"
git flow feature finish f-02

# 3
git flow feature start f-03
  echo "feature 3" >>features.txt
  cp ${GIT}/*.md .
  git add .
  git commit -m "segunda feature"
git flow feature finish f-03

git push origin develop
git push origin master

git flow release start 0.1
echo 0.1: Primeiro release. > releases.txt
git add .
git commit -m "Primeiro release"
git flow release finish '0.1'

echo
echo bye
# ----------------------------------------------------------------------------
exit 0
