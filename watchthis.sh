#!/bin/bash

_watchthis_incronflags="IN_MODIFY,IN_CLOSE_WRITE,IN_CREATE,IN_MOVED_TO,IN_ATTRIB"

watchthis()
{
    thisdir=$(pwd | sed -e 's/ /\\ /g')
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    dirs=$(find `pwd` -type d -print)
    for dir in $dirs; do
        edir=$(echo $dir | sed -e 's/ /\\ /g')
        echo "Adding $edir to incrontab."
        echo "$edir $_watchthis_incronflags /usr/bin/rsync -atz $thisdir/ $1:~/">>/var/spool/incron/darnold
    done
    IFS=$SAVEIFS
    incrontab --reload
}

complete -F _ssh watchthis