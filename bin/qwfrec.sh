#!/bin/sh
pkill -2 -x wf-recorder&&exit
wf-recorder "$@" -x yuv420p -c libx265 -r 24 -f "$HOME"/pic/screenshots/v"$(date +"%Y%m%d%H%M%S")".mp4
