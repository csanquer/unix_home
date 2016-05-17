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

#########################################
###  import variable configuration    ###
#########################################

CONFIG_FILE=build.conf
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
USAGE : $0 [-h] <sslconf>

sslconf : SSL variables config file :

domain=
commonname=\$domain
country=
state=
locality=
organization=
organizationalunit=
email=
password=

options availables :
  -h    :   print this help
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
while getopts  "hc:" flag
do
 # debug
 # echo "$flag" $OPTIND $OPTARG
  case $flag in

    # display help if -h or unknown option
    h|\?)
      printHelp
      ;;
    #to complete ....

    # all others cases
    *)
      ;;
  esac
done
# remove options from command line parameters
shift `expr $OPTIND - 1`

# process arguments

if [ $# -lt 1 ] ;
then
  printHelp
  exit 0;
fi

sslconf=$1

########################################
###          Main program            ###
########################################

source $sslconf

#Create the request
echo "Creating CSR"
mkdir -p $domain

openssl req -nodes -newkey rsa:2048 -keyout $domain/$domain.key -out $domain/$domain.csr -passin pass:$password \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

cat << EOF | tee $domain/$domain.conf
domain="$domain"
commonname="$commonname"
country="$country"
state="$state"
locality="$locality"
organization="$organization"
organizationalunit="$organizationalunit"
email=$email
password=$password
EOF

echo "---------------------------"
echo "-----Below is your CSR-----"
echo "---------------------------"
echo
cat $domain/$domain.csr

echo
echo "---------------------------"
echo "-----Below is your Key-----"
echo "---------------------------"
echo
cat $domain/$domain.key
