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
###      default config variable      ###
#########################################

tagField=
tagCreate=0
tagCommit=HEAD
tagDefault=0.1.0
tagQuiet=0
tagAllowSameTag=1

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
USAGE : $0 [-h] [-f <field>] [-a] [-c <commit>] [-d <default-tag>] [-q] [-s]
options availables : 
  -h : print this help
  -f : version field to increment (patch : v0.0.x , minor : v0.x.0 , major : vx.0.0 )
  -a : create git tag 
  -c : tag to create will refer this commit
  -d : default tag to use 
  -s : do not allow creating an new tag on the previous tag commit 
  -q : output only the next tag
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
while getopts  "hf:ac:d:qs" flag
do
 # debug
 # echo "$flag" $OPTIND $OPTARG
  case $flag in  

    # display help if -h or unknown option
    h|\?)
      printHelp 
      ;;  
    f)
      tagField=$OPTARG
      ;;  
    a)
      createTag=1
      ;;  
    c)
      commit=$OPTARG
      ;;  
    d)
      defaultTag=$OPTARG
      ;;  
    q)
      quiet=1
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

currentTag=`git describe --tags --abbrev=0 2> /dev/null`
currentFullTag=`git describe --tags 2> /dev/null`

if [[ $tagAllowSameTag -eq 0 ]] ; then
    if [ "$currentTag" == "$currentFullTag" ]; then
        if [[ $tagQuiet -eq 0 ]] ; then
            echo you are already on the latest tag $currentTag
        fi
        exit 1
    fi
fi


tag=$(echo $currentTag | awk 'match($0, /[0-9]+(\.[0-9]+)+/) { print substr( $0, RSTART, RLENGTH )}')

if [[ $tagQuiet -eq 0 ]] ; then
    #echo current Full Tag : $currentFullTag
    echo current Tag : $currentTag
fi

if [[ -n "$tag" ]] ; then 
    if [ "$tagField" != 'patch' -a "$tagField" != 'minor' -a "$tagField" != 'major' ] ; then 
        PS3="Please choose a version field to increment : "
        select option in 'Patch Number (v0.0.x)' 'Minor Version (v0.x.0)' 'Major Version (vx.0.0)'
        do
            case "$option" in
                'Patch Number (v0.0.x)')
                    tagField="patch"
                    break
                    ;;
             
                'Minor Version (v0.x.0)')
                    tagField=minor
                    break
                    ;;
                'Major Version (vx.0.0)')
                    tagField=major
                    break
                    ;;
            esac
        done
    fi

    case "$tagField" in
        'patch')
            nextTag=$(echo $tag | awk 'BEGIN{FS="."} { print $1+0 "." $2+0 "." $3+1;}')
            ;;
     
        'minor')
            nextTag=$(echo $tag | awk 'BEGIN{FS="."} { print $1+0 "." $2+1 ".0";}')
            ;;
     
        'major')
            nextTag=$(echo $tag | awk 'BEGIN{FS="."} { print $1+1 ".0.0";}')
            ;;
    esac
else
    nextTag=$(echo $tagDefault | awk 'match($0, /[0-9]+(\.[0-9]+)+/) { print substr( $0, RSTART, RLENGTH )}')
fi

nextTag=v$nextTag

if [[ $tagQuiet -eq 0 ]] ; then
    echo next Tag : $nextTag
else 
    echo $nextTag
fi

if [[ $tagCreate -eq 1 ]] ; then
    if [[ $tagQuiet -eq 0 ]] ; then
       echo creating tag $nextTag in git repository on commit $tagCommit
    fi
    git tag $nextTag $tagCommit -m "$nextTag $tagField version"
fi

