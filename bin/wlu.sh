#!/bin/sh
brightnessctl s "$1"
brightnessctl -q g >> "$XDG_CACHE_HOME/wlu"
