#!/bin/bash


#########################################
###       Bash script location        ###
#########################################

realpath() {
  OURPWD=$PWD
  cd "$(dirname "$1")"
  LINK=$(readlink "$(basename "$1")")
  while [ "$LINK" ]; do
    cd "$(dirname "$LINK")"
    LINK=$(readlink "$(basename "$1")")
  done
  REALPATH="$PWD/$(basename "$1")"
  cd "$OURPWD"
  echo "$REALPATH"
}

# current script command line call
#Work for GNU Linux and BSD and MacOSX
scriptCall="$(realpath "${BASH_SOURCE[0]}")"
# only work on GNU Linux
#scriptCall="$(readlink -f ${BASH_SOURCE[0]})"
# directory of the script
scriptDir=$(dirname "$scriptCall")
# script base name
scriptName=$(basename "$scriptCall")

#########################################
###        OS basic detection         ###
#########################################

case "$OSTYPE" in
  linux*)
    currentOS="linux";;
  darwin*)
    currentOS="macosx";;
  solaris*)
    currentOS="solaris";;
  cygwin)
    currentOS="windows";;
  win*)
    currentOS="windows";;
  freebsd*)
    currentOS="bsd";;
  bsd*)
    currentOS="bsd";;
  *)
    currentOS="unknown";;
esac


########################################
###          Main program            ###
########################################

# install dependencies
sudo apt-get install -y git vim screen tmux ack-grep zsh

cd $scriptDir/home
cp -R -u -v . ~/

cd $scriptDir

# install Vundle : VIM bundle manager
if [ ! -d ~/.vim/bundle/Vundle.vim ];then
    git clone https://github.com/gmarik/Vundle.vim.git  ~/.vim/bundle/Vundle.vim
fi
# install vim plugins by vundle
vim +PluginInstall +qall

# install OH my ZSH
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
fi

# Copy oh-my-zsh theme
cp -R -u -v $scriptDir/home/.oh-my-zsh ~/
