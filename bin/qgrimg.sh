#!/bin/sh
grim "$@" -g "$(slurp)" "$HOME"/pic/screenshots/s"$(date +"%Y%m%d%H%M%S")".png
