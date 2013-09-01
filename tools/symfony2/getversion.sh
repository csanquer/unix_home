#!/bin/bash

defaultConfig=app/config/parameters.yml
versionKeyword=version
versionDateKeyword=version_date

version=
versionDate=

if [ $# -gt 0 ]; then
    configFiles="$@"
else
    configFiles=$defaultConfig
fi

if ! type "git" > /dev/null 2>&1; then
  echo unable to retrieve version, git is not installed
else
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
                sed  -i 's/\('"$versionKeyword"':\)\s*.*$/\1 '"\""''"$version"''"\""'/' $file
                sed  -i 's/\('"$versionDateKeyword"':\)\s*.*$/\1 '"\""''"$versionDate"''"\""'/' $file
            fi
        done
    fi
fi
