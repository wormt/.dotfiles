#!/bin/sh
amixer -qD default sset Master "$1"
amixer sget Master | awk -F"[][]" '/Left:/ { print $2-0}' >> "$XDG_CACHE_HOME/wgv"
