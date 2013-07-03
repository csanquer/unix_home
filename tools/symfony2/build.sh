#!/bin/bash

phpbin=php
curlbin=curl

composerOptions='--prefer-source --no-dev --optimize-autoloader'
#composerOptions='--prefer-dist  --no-dev --optimize-autoloader'

assetOptions='--symlink --relative'
#assetOptions=''

#get or update composer locally
if [ -f composer.phar ]; then
    $phpbin composer.phar self-update
else
    $curlbin -sS https://getcomposer.org/installer | $phpbin 
fi

# update vendors
if [ -f composer.phar ]; then
    $phpbin composer.phar install $composerOptions
fi

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
