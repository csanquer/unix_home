#!/bin/bash

#########################################
###       Bash script location        ###
#########################################

# current script command line call
scriptCall="$(readlink -f ${BASH_SOURCE[0]})"
# directory of the script
scriptDir="$(dirname $scriptCall)"
# script base name
scriptName="$(basename $scriptCall)"

#########################################
###  import variable configuration    ###
#########################################

#CONFIG_FILE=my_script.conf

#if [[ -f $CONFIG_FILE ]]; then
#    . $CONFIG_FILE
#fi

#########################################

# disable apc in cli mode to avoid composer errors
phpbin='php -d apc.enable_cli=0'
#phpbin=php

#globalcomposerbin=/usr/local/bin/composer
globalcomposerbin=composer

# curl through proxy
#curlOptions="--proxy <[protocol://][user@password]proxyhost[:port]> "
curlOptions=""


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

