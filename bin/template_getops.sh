#!/bin/bash

#########################################
###          options processing       ###
#########################################

# display help
function printHelp()
{
  cat << EOF
help
USAGE : $0 [-h] ARG1
options availables : 
  -h    :   print this help
EOF

  exit
  # to complete
}

# check required parameter number
if [ $# -lt 0 ] ; 
then
  printHelp;
fi

# process options 
# pattern => letter = option ; letter with ':' = option with required parameter
# example "hcd:o:" => h and c don't require parameter but d and o require parameter
# var $OPTIND is options index 
#     $OPTARG is option parameter value 
while getopts  "hapu:" flag
do
 # debug
 # echo "$flag" $OPTIND $OPTARG
  case $flag in  

    # disply help if -h or unknown option
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

arg1=$1

########################################
