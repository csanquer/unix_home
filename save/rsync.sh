#!/bin/bash
sourceDir=''
targetDir=''

options='-avzh -C --del --progress --stats'
ssh="-e 'ssh'"
dryrun='dry run'

if [[ $# -eq 1 ]];
then
    if [[ $1 = '-g' ]] ;
    then
        dryrun=''
    fi
fi

if [[ $dryrun = 'dry run' ]];
then
    echo 'dry run'
else
    echo 'normal run'
fi

echo "rsync $options $dryrun $ssh $sourceDir $targetDir"
rsync $options $dryrun $ssh $sourceDir $targetDir
