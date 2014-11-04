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

#########################################
###  default variable configuration   ###
#########################################

defaultConfig=app/config/parameters.yml

versionFile=VERSION

versionKeyword=version
branchKeyword=version_branch
shortcommitKeyword=version_short_commit
commitKeyword=version_commit
timestampKeyword=version_timestamp
dateKeyword=version_date
assetdateKeyword=assets_version

version=
branch=
shortcommit=
commit=
timestamp=
isodate=
assetdate=

#########################################
###  import variable configuration    ###
#########################################

CONFIG_FILE=../build.conf
CONFIG_FILE_DIST=$CONFIG_FILE.dist

if [[ -f $CONFIG_FILE ]]; then
    . $CONFIG_FILE
elif [[ -f $CONFIG_FILE_DIST ]]; then
    . $CONFIG_FILE_DIST
fi

#########################################
###          options processing       ###
#########################################

# display help
function printHelp()
{
  cat << EOF
help
USAGE : $0 [-h] [-f <version_file>] [config_file0 config_file1 ... config_fileN]
options availables : 
  -h : print this help
  -f : version file to source (default = VERSION)
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
while getopts  "hf:" flag
do
 # debug
 # echo "$flag" $OPTIND $OPTARG
  case $flag in  

    # display help if -h or unknown option
    h|\?)
      printHelp 
      ;;
    f)
      versionFile=$OPTARG
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

if [ "$currentOS" == 'macosx' -o "$currentOS" == 'bsd' ] ; then
    sedcmd="sed -i ''"
else
    sedcmd="sed -i"
fi

#get config files from CLI or use default config file
if [ $# -gt 0 ]; then
    configFiles="$@"
else
    configFiles=$defaultConfig
fi
echo $versionFile
# test if git is available
if [[ -f $versionFile ]]; then

    . $versionFile

echo $version
echo $branch
echo $shortcommit
echo $commit
echo $timestamp
echo $isodate
echo $assetdate

    for file in $configFiles
    do
        if [ -f $file ]; then
            $sedcmd 's/^\(\s*\)#\?\(\s*\)\('"$versionKeyword"':\)\s*.*$/\1\2\3 '"\""''"$version"''"\""'/' $file
            $sedcmd 's#^\(\s*\)\#\?\(\s*\)\('"$branchKeyword"':\)\s*.*$#\1\2\3 '"\""''"$branch"''"\""'#' $file
            $sedcmd 's/^\(\s*\)#\?\(\s*\)\('"$shortcommitKeyword"':\)\s*.*$/\1\2\3 '"\""''"$shortcommit"''"\""'/' $file
            $sedcmd 's/^\(\s*\)#\?\(\s*\)\('"$commitKeyword"':\)\s*.*$/\1\2\3 '"\""''"$commit"''"\""'/' $file
            $sedcmd 's/^\(\s*\)#\?\(\s*\)\('"$timestampKeyword"':\)\s*.*$/\1\2\3 '"\""''"$timestamp"''"\""'/' $file
            $sedcmd 's/^\(\s*\)#\?\(\s*\)\('"$dateKeyword"':\)\s*.*$/\1\2\3 '"\""''"$isodate"''"\""'/' $file
            $sedcmd 's/^\(\s*\)#\?\(\s*\)\('"$assetdateKeyword"':\)\s*.*$/\1\2\3 '"\""''"$assetdate"''"\""'/' $file
        fi
    done
fi
