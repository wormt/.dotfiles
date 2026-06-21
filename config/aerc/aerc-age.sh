#!/bin/sh
umask 0177
age -d -i ~/.age/anon.priv -o /tmp/accounts.conf ~/.config/aerc/accounts.conf.age
umask 0077
/usr/bin/aerc -A /tmp/accounts.conf
nohup shred -u /tmp/accounts.conf 2>&1 /dev/null&exit
