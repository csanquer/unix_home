#!/bin/bash

config=app/config/parameters.yml
versionKeyword=version
versionDateKeyword=version_date

if ! type "git" > /dev/null 2>&1; then
  echo unable to retrieve version, git is not installed
else
    if [ -d .git ]; then
        versionDate=`git log -1 --pretty=format:'%ci' --date=local`
        version=`git describe --tags 2> /dev/null`

        if [ $? != 0 ]; then
            #version=`git describe --all 2> /dev/null`
            #hash=`git log -1 --pretty=format:%h 2> /dev/null`
            #version=$version-$hash
            version=`git log -1 --pretty=format:%h 2> /dev/null`
        fi
    else 
        version=
        versionDate=
    fi

    if [ -n "$version" ]; then
        echo Version : $version

        if [ -f $config ]; then
            sed  -i 's/\('"$versionKeyword"':\)\s*.*$/\1 '"\""''"$version"''"\""'/' $config
        fi

        if [ -n "$versionDate" ]; then
            echo Version Date : $versionDate

            if [ -f $config ]; then
                sed  -i 's/\('"$versionDateKeyword"':\)\s*.*$/\1 '"\""''"$versionDate"''"\""'/' $config
            fi
        fi
    fi
fi
