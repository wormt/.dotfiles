#!/bin/sh
umask 0177
age -d -i ~/.age/anon.priv -o /tmp/accounts.conf ~/.config/aerc/accounts.conf.age
umask 0077
"$(/home/linuxbrew/.linuxbrew/bin/aerc -A /tmp/accounts.conf;
find ~/.cache/aerc -type f -exec shred -u {} \;
rm -rf ~/.cache/aerc;
sleep 1)"&
sleep 5;shred -u /tmp/accounts.conf
