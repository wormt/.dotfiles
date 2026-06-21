#!/bin/sh
if [ -w "$XDG_CONFIG_HOME"/yambar/wfs ];then
	rm "$XDG_CONFIG_HOME"/yambar/wfs
fi
if [ -w "$XDG_CONFIG_HOME"/polybar/wfs ];then
	rm "$XDG_CONFIG_HOME"/polybar/wfs
fi
#exec /usr/bin/pipewire&
#xcompmgr&
#redshift -l 37:-117 -t 6500:3000&
#dunst&
#/usr/libexec/xdg-desktop-portal-lxqt&
#feh --bg-fill "$(ls -d1 $HOME/pic/hh/*.*|shuf -n 1)"&
#polybar&
#mpd --no-daemon&
#yambar&
#xrandr --output HDMI-A-0 --mode 640x480 --rate 60&
