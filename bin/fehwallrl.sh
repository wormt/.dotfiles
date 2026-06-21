#!/bin/sh
feh --no-fehbg --bg-fill "$(ls -d1 $HOME/pic/hh/*.*|shuf -n 1)"
