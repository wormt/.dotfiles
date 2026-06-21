#!/bin/sh
pkill -x swaybg
if [ -z "$1" ]; then
	exec swaybg -i "$(ls -d1 $HOME/pic/hh/*.*|sort -R|head -n 1)"&
else
	exec swaybg -i "$1"&
fi
