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

field=
createTag=0
commit=HEAD
defaultTag=0.1.0
quiet=0

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
USAGE : $0 [-h] [-f <field>] [-a] [-c <commit>] [-d <default-tag>] [-q]
options availables : 
  -h : print this help
  -f : version field to increment (patch : v0.0.x , minor : v0.x.0 , major : vx.0.0 )
  -a : create git tag 
  -c : tag to create will refer this commit
  -d : default tag to use 
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
while getopts  "hf:ac:d:q" flag
do
 # debug
 # echo "$flag" $OPTIND $OPTARG
  case $flag in  

    # display help if -h or unknown option
    h|\?)
      printHelp 
      ;;  
    f)
      field=$OPTARG
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

if [ "$currentTag" != "$currentFullTag" -o -z "$currentTag" ]; then
    tag=$(echo $currentTag | awk 'match($0, /[0-9]+(\.[0-9]+)+/) { print substr( $0, RSTART, RLENGTH )}')
    
    if [[ $quiet -eq 0 ]] ; then
        #echo current Full Tag : $currentFullTag
        echo current Tag : $currentTag
    fi
    
    if [[ -n "$tag" ]] ; then 
        if [ "$field" != 'patch' -a "$field" != 'minor' -a "$field" != 'major' ] ; then 
            PS3="Please choose a version field to increment : "
            select option in 'Patch Number (v0.0.x)' 'Minor Version (v0.x.0)' 'Major Version (vx.0.0)'
            do
                case "$option" in
	                'Patch Number (v0.0.x)')
	                    field="patch"
                        break
		                ;;
                 
	                'Minor Version (v0.x.0)')
	                    field=minor
	                    break
	                    ;;
	                'Major Version (vx.0.0)')
	                    field=major
	                    break
		                ;;
                esac
            done
        fi

        case "$field" in
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
        nextTag=$(echo $defaultTag | awk 'match($0, /[0-9]+(\.[0-9]+)+/) { print substr( $0, RSTART, RLENGTH )}')
    fi

    nextTag=v$nextTag

    if [[ $quiet -eq 0 ]] ; then
        echo next Tag : $nextTag
    else 
        echo $nextTag
    fi

    if [[ $createTag -eq 1 ]] ; then
        if [[ $quiet -eq 0 ]] ; then
           echo creating tag $nextTag in git repository on commit $commit
        fi
        git tag $nextTag $commit -m "$nextTag $field version"
    fi
else
    if [[ $quiet -eq 0 ]] ; then
        echo you are already on the latest tag $currentTag
#    else
#        echo $currentTag
    fi
fi

