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

phpbin=php
curlbin=curl

assetOptions='--symlink --relative'
#assetOptions=''

#install vendors
bash composer.sh

# clear cache
$phpbin app/console cache:clear --env=dev
$phpbin app/console cache:clear --env=prod

# install assets
$phpbin app/console assets:install $assetOptions web 

$phpbin app/console assetic:dump --env=dev
$phpbin app/console assetic:dump --env=prod --no-debug

# build model and check for database migration
$phpbin app/console propel:build
rm app/propel/migrations/PropelMigration*
$phpbin app/console propel:migration:generate-diff
$phpbin app/console propel:migration:status

read -p "migrate database (y/n) ? " -n 1 migrate
echo ""
if [ "$migrate" == "y" -o "$migrate" == "Y" ]; then
    $phpbin app/console propel:migration:migrate 
fi
