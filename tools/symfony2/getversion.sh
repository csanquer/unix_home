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
###      default config variable      ###
#########################################

defaultConfig=app/config/parameters.yml
versionKeyword=version
versionDateKeyword=version_date
assetVersionDateKeyword=assets_version

forceDefaultVersion=0
defaultVersion=
version=
versionDate=
assetVersionDate=

#########################################
###          options processing       ###
#########################################

# display help
function printHelp()
{
  cat << EOF
help
USAGE : $0 [-h] [-f] [-d <default-version>]
options availables : 
  -h : print this help
  -f : force use of default version if provided
  -d : default version to use
EOF

  exit
  # to complete
}

# check required parameter number
if [[ $# -lt 0 ]] ; 
then
  printHelp;
fi

# process options
#
# pattern => letter = option ; letter with ':' = option with required parameter
# example "hcd:o:" => h and c don't require parameter but d and o require parameter
# var $OPTIND is options index 
#     $OPTARG is option parameter value 
while getopts  "hfd:" flag
do
 # debug
 # echo "$flag" $OPTIND $OPTARG
  case $flag in  

    # display help if -h or unknown option
    h|\?)
      printHelp 
      ;;  
    f)
      forceDefaultVersion=1
      ;;  
    d)
      defaultVersion=$OPTARG
      ;;  
    # all others cases
    *)
      ;;
  esac
done
# remove options from command line parameters
shift `expr $OPTIND - 1`

# process arguments

if [ $# -lt 0 ] ;
then
  printHelp
  exit 0;
fi

arg1=$1

########################################
###          Main program            ###
########################################

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
        
        assetVersionDate=`date +"%Y%m%d%H%M%S" --date="$versionDate"`
        
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

    if [ -z "$version" -a -n "$defaultVersion" ]; then
        version=$defaultVersion
    fi

    if [[ $forceDefaultVersion -eq 1 ]]; then
        version=$defaultVersion
    fi

    if [ -n "$version" -a -n "$versionDate" ]; then
        echo Version : $version
        echo Version Date : $versionDate
        echo Asset Version Date : $assetVersionDate

        for file in $configFiles
        do
            if [ -f $file ]; then
                sed  -i'' 's/^\(\s*\)#\?\(\s*\)\('"$versionKeyword"':\)\s*.*$/\1\2\3 '"\""''"$version"''"\""'/' $file
                sed  -i'' 's/^\(\s*\)#\?\(\s*\)\('"$versionDateKeyword"':\)\s*.*$/\1\2\3 '"\""''"$versionDate"''"\""'/' $file
                sed  -i'' 's/^\(\s*\)#\?\(\s*\)\('"$assetVersionDateKeyword"':\)\s*.*$/\1\2\3 '"\""''"$assetVersionDate"''"\""'/' $file
            fi
        done
    fi
fi
