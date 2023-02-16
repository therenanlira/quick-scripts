#!/bin/bash

OLDNAME=
NEWNAME=

for i in $(ls -d */ | sed -e 's/\///g'); do
    cd $i;
    git remote set-url origin $(git remote -v | awk -F' ' '{ print $2; exit}' | sed -e "s/$OLDNAME/$NEWNAME/");
    cd ..
done