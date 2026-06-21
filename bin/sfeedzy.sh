#!/bin/sh
sfeed_plain "$HOME"/.sfeed/feeds/*|
fzf|
#fzy -l 64 -p ''|
awk -F ' ' '{print $NF}'|
sed 's/piped.private.coffee/www.youtube.com/'|
if [ "$XDG_SESSION_TYPE" = 'wayland' ];then
wl-copy
else
xclip -sel clip
fi
