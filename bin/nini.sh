#!/bin/sh
if [ -z $1 ];then
	brightnessctl g>"$HOME"/.cache/nini
	brightnessctl s 1
elif [ ! -z $1 ];then
	brightnessctl s "$(cat $HOME/.cache/nini)"
fi
