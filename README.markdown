watchthis
=========

Automatically rsync directories to a remote path using incron. --delete is not used,
so your files are safe from your own stupidity, for the most part.

Get this repo, then put `source /path/to/watchthis.sh` in your bashrc.
In the directory you want to watch, type

    watchthis remotepath

Where remotepath is an rsync compatible path. If you want to remove the watches,
from the directory you issued the command in just run:

    dontwatch

And the relevant entries will be removed from your incrontab.

If you don't have incron installed, and you're running something like Debian:

    sudo apt-get install incron

Then add your username to `/etc/incron.allow` and issue `sudo service incron restart`.