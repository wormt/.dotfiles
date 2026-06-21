#!/bin/sh
pkill -2 -x swayidle||exec swayidle -w timeout 300 "nini" resume "nini 0" timeout 900 "swaylock -f;sleep 3;wlopm --off eDP-1" resume "wlopm --on eDP-1"
