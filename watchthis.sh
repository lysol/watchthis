#!/bin/bash

_watchthis_incronflags="IN_MODIFY,IN_CLOSE_WRITE,IN_CREATE,IN_MOVED_TO,IN_ATTRIB"
_watchthis_spool=/var/spool/incron/`whoami`
_lockfile=$HOME/.watchthis-lock

# set up the sync script
if [ ! -d $HOME/bin ]; then
    mkdir $HOME/bin
fi

echo "#!/bin/bash
if [ ! -f $_lockfile ]; then
    touch $_lockfile
    echo \"Syncing \$1 to \$2\" >>$HOME/.watchthis.log
    sleep 1
    /usr/bin/env rsync -atz \"\$1\" \"\$2\" >>$HOME/.watchthis.log
    rm $_lockfile
fi
">$HOME/bin/dosync.sh
chmod +x $HOME/bin/dosync.sh

watchthis()
{
    # need to remove previous entries to do an update
    dontwatch
    thisdir=$(pwd | sed -e 's/ /\\ /g')
    SAVEIFS=$IFS
    tmpfile=/tmp/`whoami`_incrontab
    if [ -f $tmpfile ]; then
        rm $tmpfile
    fi
    IFS=$(echo -en "\n\b")
    dirs=$(find `pwd` -type d -print | sort | uniq)
    for dir in $dirs; do
        edir=$(echo $dir | sed -e 's/ /\\ /g')
        echo "processing $dir"
        echo "$edir $_watchthis_incronflags $HOME/bin/dosync.sh $thisdir/ $1">>$tmpfile
    done
    IFS=$SAVEIFS
    echo "adding"
    cat $tmpfile >> $_watchthis_spool
    rm $_lockfile
    return 0
}

dontwatch()
{
    thisdir=$(pwd | sed -e 's/ /\\\\ /g')
    tmpfile=/tmp/`whoami`_watchthis
    grep -v "dosync.sh $thisdir" $_watchthis_spool>$tmpfile
    cp $tmpfile $_watchthis_spool
}

complete -o nospace -F _rsync watchthis