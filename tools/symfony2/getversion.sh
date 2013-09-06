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

defaultConfig=app/config/parameters.yml
versionKeyword=version
versionDateKeyword=version_date

version=
versionDate=

#get config files from CLI or use default config file
if [ $# -gt 0 ]; then
    configFiles="$@"
else
    configFiles=$defaultConfig
fi

# test if git is available
if ! type "git" > /dev/null 2>&1; then
  echo unable to retrieve version, git is not installed
else
    # test if current directory is a git repository
    if [ -d .git ]; then
        versionDate=`git log -1 --pretty=format:'%ci' --date=local`
        if [ $? != 0 ]; then
            versionDate=`date +"%F %T %z"`
        fi
        
        #only based on tags
        version=`git describe --tags 2> /dev/null`
        if [ $? != 0 ]; then
            # refs + commit short hash
            #version=`git describe --all 2> /dev/null`
            #hash=`git log -1 --pretty=format:%h 2> /dev/null`
            #version=$version-$hash
            
            # only commit short ash
            version=`git log -1 --pretty=format:%h 2> /dev/null`
        fi
    else 
        echo this directory is not a git repository
    fi

    if [ -n "$version" -a -n "$versionDate" ]; then
        echo Version : $version
        echo Version Date : $versionDate

        for file in $configFiles
        do
            if [ -f $file ]; then
                sed  -i 's/^\(\s*\)#\?\(\s*\)\('"$versionKeyword"':\)\s*.*$/\1\2\3 '"\""''"$version"''"\""'/' $file
                sed  -i 's/^\(\s*\)#\?\(\s*\)\('"$versionDateKeyword"':\)\s*.*$/\1\2\3 '"\""''"$versionDate"''"\""'/' $file
            fi
        done
    fi
fi
