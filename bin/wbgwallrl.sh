#!/bin/sh
for i in wbg swaybg; do pkill -x $i;done
if [ -z "$1"]; then
	exec wbg "$(ls -d1 $HOME/pic/hh/*.*|sort -R|head -n 1)"&
else
	exec wbg "$1"&
fi
