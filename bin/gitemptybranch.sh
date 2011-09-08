#!/bin/sh

if [ -d .git ]; 
then
    if [ $# -ge 1 -a -n $1 ];
    then
        git symbolic-ref HEAD refs/heads/$1 
        rm .git/index 
        git clean -fdx
    else
        echo 'you must provide a new branch name argument'
    fi
else
    echo 'this is not a git repository'
fi
