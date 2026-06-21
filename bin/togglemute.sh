#!/bin/sh
amixer -D pipewire sset Capture 1+ toggle&&
mpv --load-scripts=no --volume=200 --no-video --player-operation-mode=cplayer "$HOME"/pic/dump/robloxsplat.opus
