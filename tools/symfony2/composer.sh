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
  linux*)   currentOS="linux";;
  darwin*)  currentOS="macosx";;
  solaris*) currentOS="solaris";;
  cygwin)   currentOS="windows";;
  win*)     currentOS="windows";;
  freebsd*) currentOS="bsd";;
  bsd*)     currentOS="bsd";;
  *)        currentOS="unknown";;
esac

#########################################
###      default config variable      ###
#########################################

# disable apc in cli mode to avoid composer errors
phpbin='php -d apc.enable_cli=0'
#phpbin=php

#globalcomposerbin=/usr/local/bin/composer
globalcomposerbin=composer

# curl through proxy
#curlOptions="--proxy <[protocol://][user@password]proxyhost[:port]> "
curlOptions=""

########################################
###          Main program            ###
########################################

########################### Composer arguments #################################
composerCommand=
composerOptions=

if [ $# -gt 0 ] ; then 
#get composer command and options from CLI
    if [ "$1" == "update" -o "$1" == "install" ] ; then
        composerCommand=$1
        shift 1
        composerOptions="$@"
    else
        composerCommand=
        composerOptions="$@"
    fi
fi

# set default composer command if no provided
if [ -z "$composerCommand" ]; then
    # update composer.lock and install vendors 
    #composerCommand='update'
    # install vendors from composer.lock
    composerCommand='install'
fi
    
# set default composer options if no provided
if [ -z "$composerOptions" ]; then
    # update vendors from VCS repositories if available
    #composerOptions='--prefer-source --optimize-autoloader'
    composerOptions='--prefer-source'
    # update vendors from downloaded archives if available without development dependencies
    #composerOptions='--prefer-dist  --no-dev --optimize-autoloader'
fi

########################### Composer ###########################################

if type -p "$globalcomposerbin" > /dev/null 2>&1; then
    #use system global composer
    composerbin=$(type -p "$globalcomposerbin")
else
    #use local project composer
    composerbin="$phpbin composer.phar"
    #get or update composer locally
    if [ -f composer.phar ]; then
        $composerbin self-update
    else
        curl -sS $curlOptions https://getcomposer.org/installer | $phpbin
        # alternative download
        #$phpbin -r "eval('?>'.file_get_contents('https://getcomposer.org/installer'));"
    fi
fi

# install or update vendors
$composerbin $composerCommand $composerOptions

