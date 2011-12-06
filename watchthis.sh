#!/bin/bash

_watchthis_incronflags="IN_MODIFY,IN_CLOSE_WRITE,IN_CREATE,IN_MOVED_TO,IN_ATTRIB"

_watchthis_spool=/var/spool/incron/`whoami`

watchthis()
{
    # need to remove previous entries to do an update
    dontwatch
    thisdir=$(pwd | sed -e 's/ /\\ /g')
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    dirs=$(find `pwd` -type d -print | sort | uniq)
    for dir in $dirs; do
        edir=$(echo $dir | sed -e 's/ /\\ /g')
        echo "$edir $_watchthis_incronflags /usr/bin/rsync -atz $thisdir/ $1">>$_watchthis_spool
    done
    IFS=$SAVEIFS
    incrontab --reload
}

dontwatch()
{
    thisdir=$(pwd | sed -e 's/ /\\\\ /g')
    tmpfile=/tmp/`whoami`_watchthis
    grep -v "atz $thisdir" $_watchthis_spool>$tmpfile
    cp $tmpfile $_watchthis_spool
    incrontab --reload
}

complete -o nospace -F _rsync watchthis