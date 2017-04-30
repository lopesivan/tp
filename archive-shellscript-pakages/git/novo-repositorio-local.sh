#!/usr/bin/env bash
GIT=${HOME}/git

#
# ----------------------------- error functions ------------------------------
#

# The error function print menssage of error.
#
_error() {
  exec 4>&1 # stdout duplicado ( FD 4 tem as mesmas caracteristicas
            # do STDOUT), aponta para o terminal.
  exec 1>&2
  echo ERROR: "$*"
  exec 1>&4 # FD 1 recebe as caracteristicas de FD 4.
            # FD 1 ressetado.
  exec 4>&- # FD 4 eh liberado.
}

# The error function print menssage of error.
#
_abort_now() {
  _error '***' aborted '***'
  exit 1
}

# Validation:
# The program requires an argument or abort the execution
#
test $# -eq 0 && { _error "Você não informou o nome do repositório"; _abort_now;}

# ----------------------------------------------------------------------------

original_dir=$PWD
dir=$(echo "$*" | sed -r 's/[  ]+/-/g')
git_dir=$GIT/${dir}.git

# create dir
test -d $dir &&
  { _error "O projeto já existe!"; _abort_now; }

# create dir
test -d $git_dir &&
  { _error "O repositório existe!"; _abort_now; } ||
    { mkdir -p $GIT/${dir}.git && cd $_; }

pwd

# Inicialize
git init --bare

# retorna para workspace
cd $original_dir
pwd

echo
echo clone:
echo ================================
echo git clone file://${HOME}/git/${dir}.git
echo ================================
echo

git clone file://${HOME}/git/${dir}.git
#git remote add origin file://${HOME}/git/${dir}.git

cd ${dir}
git flow init -d

cd ${dir}
git flow feature start goal
echo descreva a meta > GOAL
git add GOAL
git ci -m "descrição da minha meta"

git flow feature start readme
echo documentação inicial > README.md
git add README.md
git ci -m "descrição do projeto"

git flow  feature start license
echo GNU GPL versão 3 > LICENCE
git add LICENCE
git ci -m "GPLv3"

git co develop
cat <<EOF >HOWTOCLONE
#git clone file://\${HOME}/git/${dir}.git
#git remote add origin file://\${HOME}/git/${dir}.git
EOF

git add HOWTOCLONE
git ci -m "Exemplo de como clonar o projeto *${dir}*"

echo
echo bye
# ----------------------------------------------------------------------------
exit 0
