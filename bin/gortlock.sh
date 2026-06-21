#!/bin/sh
#pgrep -q swayidle||swaylock&&exit
pkill -10 swayidle;sleep 5;wlopm --off eDP-1
